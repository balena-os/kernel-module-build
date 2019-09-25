#!/bin/bash

set -o errexit

device="$1"
version="$2"
dest_folder="/usr/src/app/$3"

# Workaround for x86_64 images. Tools compiled expecting /lib/ld-linux-x86-64.so.2 while it is in /lib64 in Debian
if [ -f /lib64/ld-linux-x86-64.so.2 ]; then
	if [ ! -f /lib/ld-linux-x86-64.so.2 ]; then
		ln -s /lib64/ld-linux-x86-64.so.2  /lib/ld-linux-x86-64.so.2
	fi
fi

if [[ "$device" == asus-tinker* ]] ; then
	echo Workaround tinkerboard
	# Specific for the Asus Tinkerboard
	# Check for config option CONFIG_ARCH_ROCKCHIP and
	# if set remove the line that sets the default ARCH
	# inside the Makefile
	if grep -q "CONFIG_ARCH_ROCKCHIP=y" .config; then
		sed -i '/?= arm64/d' Makefile
	fi
fi

if [[ "$device" == beagle* ]] ; then
	echo Workaround bbb
	wget https://raw.githubusercontent.com/beagleboard/linux/4.14/arch/arm/kernel/module.lds -O "$PWD"/arch/arm/kernel/module.lds
fi

if [[ "$device" == ts4900 ]] ; then
	echo Workaround ts4900
	# Workaround for the ts4900 to deal with unknown relocation error
	# when build OOT modules
	if grep -q "ts4900" ./arch/arm/boot/dts/Makefile; then
		sed -i 's/^CFLAGS_MODULE \+=/CFLAGS_MODULE += -fno-pic/g' Makefile
        fi
fi
