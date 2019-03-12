#!/bin/bash

OS_VERSION=$(echo $RESIN_HOST_OS_VERSION | cut -d " " -f 2)
echo "OS Version is $OS_VERSION"

mod_dir="example_module_${RESIN_DEVICE_TYPE}_${OS_VERSION}*"
for each in $mod_dir; do
	echo Loading module from $each
	insmod $each/hello.ko
	lsmod | grep hello
	rmmod hello
done

while true; do
	sleep 60
done
