#!/bin/sh
set -ex
SCRIPT_DIR="`pwd`/`dirname $0`"
TDIR=`mktemp -d`
cd $TDIR
curl -fL -o openssl.tar.gz https://github.com/openssl/openssl/archive/refs/tags/OpenSSL_1_0_2n.tar.gz
tar zxf openssl.tar.gz
cd openssl-OpenSSL_1_0_2n
sh "$SCRIPT_DIR/build_crypto_impl.sh" iphoneos arm64
mkdir -p "$SCRIPT_DIR/../Libraries/openssl/lib"
cp .build/iphoneos/arm64/libcrypto.a "$SCRIPT_DIR/../Libraries/openssl/lib/libcrypto.a"
cp -rf "$TDIR/openssl-OpenSSL_1_0_2n/include" "$SCRIPT_DIR/../Libraries/openssl/"
cd -
rm -rf $TDIR
exit 0
