#!/bin/sh
set -ex
SCRIPT_DIR=`dirname "$0"`
TDIR=`mktemp -d`
cd $TDIR
git clone https://github.com/bitcoin-core/secp256k1.git src
SDKPATH=`xcrun -sdk iphoneos --show-sdk-path`
TARGETDIR="$TDIR/.build/device"
mkdir -p "$TARGETDIR"
(cd src && ./autogen.sh)
(cd src && ./configure --host=arm-apple-darwin \
  CC=`xcrun -find clang` \
  CFLAGS="-O3 -arch arm64 -isysroot $SDKPATH -mios-version-min=12.0" \
  --prefix="$TARGETDIR" --enable-module-recovery && make install)
cd -
mkdir -p "$SCRIPT_DIR/../Libraries/secp256k1/lib"
cp "$TARGETDIR/lib/libsecp256k1.a" "$SCRIPT_DIR/../Libraries/secp256k1/lib/libsecp256k1.a"
cp -rf $TDIR/src/include "$SCRIPT_DIR/../Libraries/secp256k1"
rm -rf $TDIR
exit 0
