#!/bin/bash

OS_VERSION=$(echo "$BALENA_HOST_OS_VERSION" | cut -d " " -f 2)
echo "OS Version is $OS_VERSION"

cd output
mod_dir="firmware_loader_${BALENA_DEVICE_TYPE}_${OS_VERSION}*"
for each in $mod_dir; do
	echo Loading module from "$each"
	insmod "$each/test_firmware.ko"
	lsmod | grep test_firmware
	rmmod test_firmware
done

while true; do
	sleep 60
done
