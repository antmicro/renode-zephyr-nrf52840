#!/bin/bash -xeu

export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
export ZEPHYR_BASE=$(pwd)/zephyr
export ZEPHYR_SDK_INSTALL_DIR=$(pwd)/zephyr-sdk

mkdir artifacts
pushd zephyr

west build -p auto -b nrf52840dk_nrf52840 samples/hello_world -- -G'Unix Makefiles'
cp build/zephyr/zephyr.elf ../artifacts/zephyr-hello_world.elf

west build -p auto -b nrf52840dk_nrf52840 samples/subsys/shell/shell_module -- -G'Unix Makefiles'
cp build/zephyr/zephyr.elf ../artifacts/zephyr-shell_module.elf

