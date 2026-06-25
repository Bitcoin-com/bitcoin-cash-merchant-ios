#!/bin/sh
set -ex
SDK=$1; ARCH=$2
CURRENTPATH="`pwd`"
SDK_PATH="`xcrun -sdk $SDK --show-sdk-path`"
export CROSS_TOP="`xcrun -sdk $SDK --show-sdk-platform-path`/Developer"
export CROSS_SDK="`basename $SDK_PATH`"
export BUILD_TOOLS="`xcode-select --print-path`"
export CC="`xcrun -find clang` -arch $ARCH -isysroot $SDK_PATH -Wno-ignored-optimization-argument -Wno-error -Wno-implicit-function-declaration"
TARGETDIR="$CURRENTPATH/.build/$SDK/$ARCH"
mkdir -p "$TARGETDIR"
./Configure iphoneos-cross no-shared no-dso no-hw no-engine no-ssl2 no-ssl3 no-comp no-idea no-asm no-dtls no-dtls1 no-threads no-err no-npn no-psk no-srp no-ec2m no-weak-ssl-ciphers -mios-version-min=12.0
make clean
make depend
make build_crypto
cp libcrypto.a "$TARGETDIR/libcrypto.a"
exit 0
