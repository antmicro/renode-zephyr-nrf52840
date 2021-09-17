#!/bin/sh

set -e

./prepare_zephyr.sh
./build_binaries.sh

test.sh nrf52840.robot
cp -r report.html log.html robot_output.xml artifacts
