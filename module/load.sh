#!/usr/bin/env sh
OS_VERSION=$(echo "$BALENA_HOST_OS_VERSION" | cut -d " " -f 2)
echo "OS Version is $OS_VERSION"

# Unload existing modules that could interfer
remove_module_if_loaded() {
	local module="$1"
	if lsmod | grep -q "$module"; then
		echo "Removing module $module"
		rmmod "$module"
	fi
}

remove_module_if_loaded hello
remove_module_if_loaded nouveau
remove_module_if_loaded nvidiafb

# NOTE: some modules need to be loaded in a specific order
# Update bellow logic if needed
nvidia_module="nvidia.ko"
drm_module="nvidia-drm.ko"

# Load nvidia first
module_path="$MOD_PATH/$nvidia_module"
if [ -f "$module_path" ]; then
    echo "Loading module from $module_path"
    insmod "$module_path"
fi

# Load the other modules
for file in "$MOD_PATH"/*.ko; do
    module=$(basename "$file")
    if [ "$module" = $nvidia_module ] || [ "$module" = $drm_module ]; then
        continue
    fi
    
    echo "Loading module from $file"
    insmod "$file"
done

# Load nvidia_drm last
module_path="$MOD_PATH/$drm_module"
if [ -f "$module_path" ]; then
    echo "Loading module from $module_path"
    insmod "$module_path"
fi