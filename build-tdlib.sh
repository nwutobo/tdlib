#!/bin/sh

rm -rf build/generate
rm -rf build/tdlib

mkdir -p build/generate
mkdir -p build/tdlib

TD_ROOT=$(realpath ../../)
OPENSSL_ROOT=$(realpath ./build/crypto/)
OPENSSL_CRYPTO_LIBRARY=$OPENSSL_ROOT/lib/libcrypto.a
OPENSSL_SSL_LIBRARY=$OPENSSL_ROOT/lib/libssl.a

OPENSSL_OPTIONS="-DOPENSSL_FOUND=1 \
  -DOPENSSL_ROOT_DIR=\"$OPENSSL_ROOT\" \
  -DOPENSSL_INCLUDE_DIR=\"$OPENSSL_ROOT/include\" \
  -DOPENSSL_CRYPTO_LIBRARY=\"$OPENSSL_CRYPTO_LIBRARY\" \
  -DOPENSSL_SSL_LIBRARY=\"$OPENSSL_SSL_LIBRARY\" \
  -DOPENSSL_LIBRARIES=\"$OPENSSL_SSL_LIBRARY;$OPENSSL_CRYPTO_LIBRARY\" \
  -DOPENSSL_VERSION=\"1.1.1d\""

cd build/generate
cmake $TD_ROOT || exit 1
cd ../..

cd build/tdlib
eval configure cmake -DCMAKE_BUILD_TYPE=MinSizeRel $OPENSSL_OPTIONS -DTD_HAS_MMSG=0 $TD_ROOT || exit 1
cd ../..

echo "Generating TDLib autogenerated source files..."
cmake --build build/generate --target prepare_cross_compiling || exit 1
echo "Building TDLib to for Harmattan..."
cmake --build build/tdlib --target || exit 1
