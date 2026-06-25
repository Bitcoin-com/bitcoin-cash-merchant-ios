#!/bin/sh
# Builds libsecp256k1 and libcrypto (OpenSSL) and packages each as an XCFramework
# under Libraries/. Designed for modern Xcode (no i386, no bitcode).
#
# Slices produced:
#   - ios-arm64                      (device)
#   - ios-arm64_x86_64-simulator     (fat: Apple Silicon AND Rosetta/Intel sim)
#
# The x86_64 simulator slice matters: OpenSslKit.swift / Realm ship simulator
# binaries with no arm64 slice, so CocoaPods sets
# `EXCLUDED_ARCHS[sdk=iphonesimulator*] = arm64` project-wide and the Simulator
# builds as x86_64. BitcoinKit must provide an x86_64 sim slice to match, or the
# link fails with `ld: library 'crypto' not found`.
set -ex

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
POD_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
LIBDIR="$POD_ROOT/Libraries"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

CLANG=$(xcrun -find clang)
MIN=12.0
JOBS=$(sysctl -n hw.ncpu)

IOS_SDK=$(xcrun -sdk iphoneos --show-sdk-path)
SIM_SDK=$(xcrun -sdk iphonesimulator --show-sdk-path)

############################################
# secp256k1  -> $WORK/secp-<name>/out/lib/libsecp256k1.a
############################################
build_secp() {
  NAME=$1; SDK=$2; ARCH=$3; MINFLAG=$4
  SRC="$WORK/secp256k1-src"
  if [ ! -d "$SRC" ]; then
    git clone --depth 1 https://github.com/bitcoin-core/secp256k1.git "$SRC"
    (cd "$SRC" && ./autogen.sh)
  fi
  BUILD="$WORK/secp-$NAME"
  rm -rf "$BUILD"; mkdir -p "$BUILD"
  (cd "$BUILD" && "$SRC/configure" \
    --host="$ARCH-apple-darwin" \
    CC="$CLANG" \
    CFLAGS="-O3 -arch $ARCH -isysroot $SDK $MINFLAG" \
    --prefix="$BUILD/out" \
    --enable-module-recovery \
    --enable-module-schnorrsig \
    --disable-shared --enable-static \
    --disable-tests --disable-benchmark --disable-exhaustive-tests \
    && make -j"$JOBS" install)
}

############################################
# OpenSSL 1.0.2n (libcrypto only) -> $WORK/openssl-<name>/libcrypto.a
############################################
build_crypto() {
  NAME=$1; SDK_NAME=$2; ARCH=$3; MINFLAG=$4
  SRC="$WORK/openssl-$NAME"
  rm -rf "$SRC"; mkdir -p "$SRC"
  tar zxf "$WORK/openssl.tar.gz" -C "$SRC" --strip-components 1
  SDK_PATH=$(xcrun -sdk "$SDK_NAME" --show-sdk-path)
  export CROSS_TOP="$(xcrun -sdk "$SDK_NAME" --show-sdk-platform-path)/Developer"
  export CROSS_SDK="$(basename "$SDK_PATH")"
  export CC="$CLANG -arch $ARCH -isysroot $SDK_PATH $MINFLAG -Wno-ignored-optimization-argument -Wno-error -Wno-implicit-function-declaration -Wno-deprecated-declarations"
  (cd "$SRC" \
    && ./Configure iphoneos-cross no-shared no-dso no-hw no-engine no-ssl2 no-ssl3 no-comp no-idea no-asm no-dtls no-dtls1 no-threads no-err no-npn no-psk no-srp no-ec2m no-weak-ssl-ciphers \
    && make clean \
    && make depend \
    && make -j"$JOBS" build_crypto)
  unset CC CROSS_TOP CROSS_SDK
}

# secp256k1: device(arm64), sim(arm64), sim(x86_64)
build_secp device   "$IOS_SDK" arm64  "-mios-version-min=$MIN"
build_secp sim-arm  "$SIM_SDK" arm64  "-mios-simulator-version-min=$MIN"
build_secp sim-x64  "$SIM_SDK" x86_64 "-mios-simulator-version-min=$MIN"

# OpenSSL: device(arm64), sim(arm64), sim(x86_64)
curl -fL -o "$WORK/openssl.tar.gz" https://github.com/openssl/openssl/archive/refs/tags/OpenSSL_1_0_2n.tar.gz
build_crypto device   iphoneos        arm64  "-mios-version-min=$MIN"
build_crypto sim-arm  iphonesimulator arm64  "-mios-simulator-version-min=$MIN"
build_crypto sim-x64  iphonesimulator x86_64 "-mios-simulator-version-min=$MIN"

# Device slices (single arch)
SECP_DEV="$WORK/secp-device/out/lib/libsecp256k1.a"
CRYPTO_DEV="$WORK/openssl-device/libcrypto.a"

# Fat simulator slices (arm64 + x86_64). The basename MUST match the device
# slice (libsecp256k1.a / libcrypto.a) or CocoaPods rejects the xcframework
# ("static libraries with differing binary names") and `-l` won't resolve.
mkdir -p "$WORK/sim-secp" "$WORK/sim-openssl"
SECP_SIM="$WORK/sim-secp/libsecp256k1.a"
CRYPTO_SIM="$WORK/sim-openssl/libcrypto.a"
lipo -create "$WORK/secp-sim-arm/out/lib/libsecp256k1.a" "$WORK/secp-sim-x64/out/lib/libsecp256k1.a" -output "$SECP_SIM"
lipo -create "$WORK/openssl-sim-arm/libcrypto.a"          "$WORK/openssl-sim-x64/libcrypto.a"          -output "$CRYPTO_SIM"

# Headers (deref symlinks into clean dirs)
SECP_HEADERS="$WORK/secp-headers"
rm -rf "$SECP_HEADERS"; mkdir -p "$SECP_HEADERS"
cp -RL "$WORK/secp-device/out/include/." "$SECP_HEADERS/"

CRYPTO_HEADERS="$WORK/openssl-headers"
rm -rf "$CRYPTO_HEADERS"; mkdir -p "$CRYPTO_HEADERS/openssl"
cp -RL "$WORK/openssl-device/include/openssl/." "$CRYPTO_HEADERS/openssl/"

# Sanity: every artifact must be a real ar archive
for f in "$SECP_DEV" "$SECP_SIM" "$CRYPTO_DEV" "$CRYPTO_SIM"; do
  test -f "$f" || { echo "MISSING: $f"; exit 1; }
done
lipo -info "$SECP_SIM" "$CRYPTO_SIM"

############################################
# Assemble XCFrameworks
############################################
rm -rf "$LIBDIR/secp256k1.xcframework" "$LIBDIR/openssl.xcframework"
mkdir -p "$LIBDIR"

xcodebuild -create-xcframework \
  -library "$SECP_DEV" -headers "$SECP_HEADERS" \
  -library "$SECP_SIM" -headers "$SECP_HEADERS" \
  -output "$LIBDIR/secp256k1.xcframework"

xcodebuild -create-xcframework \
  -library "$CRYPTO_DEV" -headers "$CRYPTO_HEADERS" \
  -library "$CRYPTO_SIM" -headers "$CRYPTO_HEADERS" \
  -output "$LIBDIR/openssl.xcframework"

echo ">>> Done. XCFrameworks in $LIBDIR"
ls -la "$LIBDIR"
