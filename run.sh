#!/usr/bin/env sh
OS_VERSION=$(echo "$BALENA_HOST_OS_VERSION" | cut -d " " -f 2)
echo "OS Version is $OS_VERSION"

mod_dir="${MOD_PATH}/${MOD_DIR}_${BALENA_DEVICE_TYPE}_${OS_VERSION}"

for file in "$mod_dir"/*.ko ; do
	echo Loading module from "$file"
    insmod "$file"
done

# Run the passed CMD as PID 1
exec "$@"
