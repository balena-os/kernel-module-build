#!/bin/bash

OS_VERSION=$(echo $RESIN_HOST_OS_VERSION | cut -d " " -f 2)
mod_dir="example_module_${RESIN_DEVICE_TYPE}_${OS_VERSION}*"

insmod $mod_dir/hello.ko
lsmod | grep hello
rmmod hello
echo done!

while true; do
	sleep 60
done
