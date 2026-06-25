#!/bin/sh
# Builds libsecp256k1 and libcrypto (OpenSSL) for ios-arm64 (device) and
# ios-arm64 simulator, then packages each as an XCFramework under Libraries/.
# Designed for modern Xcode (no i386, no bitcode).
set -ex

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
POD_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
LIBDIR="$POD_ROOT/Libraries"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

CLANG=$(xcrun -find clang)
MIN=12.0

############################################
# secp256k1  -> $WORK/secp-<plat>/out/lib/libsecp256k1.a
############################################
build_secp() {
  PLATFORM=$1; SDK=$2; MINFLAG=$3
  SRC="$WORK/secp256k1-src"
  if [ ! -d "$SRC" ]; then
    git clone --depth 1 https://github.com/bitcoin-core/secp256k1.git "$SRC"
    (cd "$SRC" && ./autogen.sh)
  fi
  BUILD="$WORK/secp-$PLATFORM"
  rm -rf "$BUILD"; mkdir -p "$BUILD"
  (cd "$BUILD" && "$SRC/configure" \
    --host=arm-apple-darwin \
    CC="$CLANG" \
    CFLAGS="-O3 -arch arm64 -isysroot $SDK $MINFLAG" \
    --prefix="$BUILD/out" \
    --enable-module-recovery \
    --enable-module-schnorrsig \
    --disable-shared --enable-static \
    --disable-tests --disable-benchmark --disable-exhaustive-tests \
    && make -j"$(sysctl -n hw.ncpu)" install)
}

############################################
# OpenSSL 1.0.2n (libcrypto only) -> $WORK/openssl-<plat>/libcrypto.a
############################################
build_crypto() {
  PLATFORM=$1; SDK_NAME=$2; MINFLAG=$3
  SRC="$WORK/openssl-$PLATFORM"
  rm -rf "$SRC"; mkdir -p "$SRC"
  tar zxf "$WORK/openssl.tar.gz" -C "$SRC" --strip-components 1
  SDK_PATH=$(xcrun -sdk "$SDK_NAME" --show-sdk-path)
  export CROSS_TOP="$(xcrun -sdk "$SDK_NAME" --show-sdk-platform-path)/Developer"
  export CROSS_SDK="$(basename "$SDK_PATH")"
  export CC="$CLANG -arch arm64 -isysroot $SDK_PATH $MINFLAG -Wno-ignored-optimization-argument -Wno-error -Wno-implicit-function-declaration -Wno-deprecated-declarations"
  (cd "$SRC" \
    && ./Configure iphoneos-cross no-shared no-dso no-hw no-engine no-ssl2 no-ssl3 no-comp no-idea no-asm no-dtls no-dtls1 no-threads no-err no-npn no-psk no-srp no-ec2m no-weak-ssl-ciphers \
    && make clean \
    && make depend \
    && make -j"$(sysctl -n hw.ncpu)" build_crypto)
  unset CC CROSS_TOP CROSS_SDK
}

IOS_SDK=$(xcrun -sdk iphoneos --show-sdk-path)
SIM_SDK=$(xcrun -sdk iphonesimulator --show-sdk-path)

build_secp device "$IOS_SDK" "-mios-version-min=$MIN"
build_secp sim    "$SIM_SDK" "-mios-simulator-version-min=$MIN"

curl -fL -o "$WORK/openssl.tar.gz" https://github.com/openssl/openssl/archive/refs/tags/OpenSSL_1_0_2n.tar.gz
build_crypto device iphoneos        "-mios-version-min=$MIN"
build_crypto sim    iphonesimulator "-mios-simulator-version-min=$MIN"

# Deterministic artifact paths
SECP_DEV="$WORK/secp-device/out/lib/libsecp256k1.a"
SECP_SIM="$WORK/secp-sim/out/lib/libsecp256k1.a"
CRYPTO_DEV="$WORK/openssl-device/libcrypto.a"
CRYPTO_SIM="$WORK/openssl-sim/libcrypto.a"

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
