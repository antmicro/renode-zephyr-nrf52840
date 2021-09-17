#!/bin/bash -xeu

ZEPHYR_SHA="42fccba"
ZEPHYR_SOURCE_URL="https://github.com/zephyrproject-rtos/zephyr/archive/${ZEPHYR_SHA}.zip"

mkdir zephyr
pushd zephyr

wget -Ozephyr.zip "$ZEPHYR_SOURCE_URL"
unzip zephyr.zip
rm zephyr.zip
mv zephyr-* zephyr

west init -l zephyr
west update
popd


# Finding required version of the zephyr-sdk
TOOLCHAIN_VERSION=$(curl https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/${ZEPHYR_SHA}/cmake/verify-toolchain.cmake | \
    grep --only-matching --extended --max-count=1 'TOOLCHAIN_ZEPHYR_MINIMUM_REQUIRED_VERSION [0-9]+\.[0-9]+(\.[0-9]+)?' | cut -d ' ' -f 2)
# Extend version to SemVer standard

case "$(echo $TOOLCHAIN_VERSION | tr '.' '\n' | wc -l)" in
    "2")
        SDK_VERSION=$TOOLCHAIN_VERSION.0
        ;;
    "3")
        SDK_VERSION=$TOOLCHAIN_VERSION
        ;;
    *)
        echo "Unrecognized format of SDK version : $TOOLCHAIN_VERSION" && exit 1
esac

ZEPHYR_SDK_RELEASES_URL="https://github.com/zephyrproject-rtos/sdk-ng/releases/download"
ZEPHYR_SDK_FILENAME="zephyr-sdk-${SDK_VERSION}-linux-x86_64-setup.run"
ZEPHYR_SDK_URL="$ZEPHYR_SDK_RELEASES_URL/v$SDK_VERSION/$ZEPHYR_SDK_FILENAME"

export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
export ZEPHYR_SDK_INSTALL_DIR=$(pwd)/zephyr/sdk

wget $ZEPHYR_SDK_URL
chmod +x $ZEPHYR_SDK_FILENAME
./$ZEPHYR_SDK_FILENAME -- -y -d $ZEPHYR_SDK_INSTALL_DIR
rm $ZEPHYR_SDK_FILENAME
