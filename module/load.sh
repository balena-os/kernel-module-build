#!/usr/bin/env sh
OS_VERSION=$(echo "$BALENA_HOST_OS_VERSION" | cut -d " " -f 2)
echo "OS Version is $OS_VERSION"

# NOTE: some modules need to be loaded in a specific order
# if that's the case, replace the loop below with a list of
# `insmod $mod_dir/<module>.ko` commands in the right order
for file in "$MOD_PATH"/*.ko; do
	if lsmod | grep -q hello; then
		rmmod hello
	fi
	echo Loading module from "$file"
	insmod "$file"
done
