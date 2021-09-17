#!/bin/bash -xeu

export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
export ZEPHYR_BASE=$(pwd)/zephyr/zephyr
export ZEPHYR_SDK_INSTALL_DIR=$(pwd)/zephyr/sdk

mkdir artifacts

pushd $ZEPHYR_BASE/samples/hello_world
west build -p auto -b nrf52840dk_nrf52840 -- -G'Unix Makefiles'
popd
cp $ZEPHYR_BASE/samples/hello_world/build/zephyr/zephyr.elf artifacts/zephyr-hello_world.elf

pushd $ZEPHYR_BASE/samples/subsys/shell/shell_module
west build -p auto -b nrf52840dk_nrf52840 -- -G'Unix Makefiles'
popd
cp $ZEPHYR_BASE/samples/subsys/shell/shell_module/build/zephyr/zephyr.elf artifacts/zephyr-shell_module.elf

