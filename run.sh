#!/bin/bash

mod_dir="example_module_${RESIN_DEVICE_TYPE}_${RESIN_HOST_OS_VERSION}"

insmod $mod_dir/hello.ko
lsmod | grep hello
rmmod hello
echo done!

while true; do
	sleep 60
done
