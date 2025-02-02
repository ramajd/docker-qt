#!/bin/bash

set -e

cd /opt
tar xvfp /root/export/Qt-amd64-$1.tar.xz

cd
git clone https://github.com/KDAB/android_openssl
cd android_openssl
git checkout f5d857ef1d437595f7c3ab0d06e61beae7ca8b99

cd
git clone --verbose --depth 1 --branch v$1 https://code.qt.io/qt/qt5.git
cd qt5
perl init-repository
cd ..
mkdir build

cd build
../qt5/configure -release -nomake examples -nomake tests -platform android-clang -prefix /opt/Qt-android-$1/android_armv7 -android-ndk $ANDROID_NDK_ROOT -android-sdk $ANDROID_SDK_ROOT -qt-host-path /opt/Qt-amd64-$1 -android-abis armeabi-v7a -- -DOPENSSL_ROOT_DIR=/root/android_openssl/static -DOPENSSL_CRYPTO_LIBRARY=/root/android_openssl/static
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-android-$1/android_armv7

rm -rf *
../qt5/configure -release -nomake examples -nomake tests -platform android-clang -prefix /opt/Qt-android-$1/android_arm64_v8a -android-ndk $ANDROID_NDK_ROOT -android-sdk $ANDROID_SDK_ROOT -qt-host-path /opt/Qt-amd64-$1 -android-abis arm64-v8a -- -DOPENSSL_ROOT_DIR=/root/android_openssl/static -DOPENSSL_CRYPTO_LIBRARY=/root/android_openssl/static
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-android-$1/android_arm64_v8a

rm -rf *
../qt5/configure -release -nomake examples -nomake tests -platform android-clang -prefix /opt/Qt-android-$1/android_x86 -android-ndk $ANDROID_NDK_ROOT -android-sdk $ANDROID_SDK_ROOT -qt-host-path /opt/Qt-amd64-$1 -android-abis x86 -- -DOPENSSL_ROOT_DIR=/root/android_openssl/static -DOPENSSL_CRYPTO_LIBRARY=/root/android_openssl/static
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-android-$1/android_x86

rm -rf *
../qt5/configure -release -nomake examples -nomake tests -platform android-clang -prefix /opt/Qt-android-$1/android_x86_64 -android-ndk $ANDROID_NDK_ROOT -android-sdk $ANDROID_SDK_ROOT -qt-host-path /opt/Qt-amd64-$1 -android-abis x86_64 -- -DOPENSSL_ROOT_DIR=/root/android_openssl/static -DOPENSSL_CRYPTO_LIBRARY=/root/android_openssl/static
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-android-$1/android_x86_64

cd /opt
tar cvfpJ /root/export/Qt-android-$1.tar.xz Qt-android-$1