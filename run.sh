#!/usr/bin/env sh
OS_VERSION=$(echo "$BALENA_HOST_OS_VERSION" | cut -d " " -f 2)
echo "OS Version is $OS_VERSION"

mod_dir="${MOD_PATH}/${MOD_DIR}_${BALENA_DEVICE_TYPE}_${OS_VERSION}"

# NOTE: some modules need to be loaded in a specific order
# if that's the case, replace the loop below with a list of
# `insmod $mod_dir/<module>.ko` commands in the right order
for file in "$mod_dir"/*.ko; do
	echo Loading module from "$file"
	insmod "$file"
done

# Pass the CMD to the entrypoint from the base images
# Run the passed CMD as PID 1
exec /usr/bin/entry.sh "$@"
