#!/bin/bash

trap 'balena-idle' ERR EXIT

OS_VERSION=$(echo "${BALENA_HOST_OS_VERSION}" | cut -d " " -f 2)

echo "Device Type is ${BALENA_DEVICE_TYPE}"
echo "OS Version is ${OS_VERSION}"

./build.sh build --device "${BALENA_DEVICE_TYPE}" --os-version "${OS_VERSION}" --src example_module

cd output || exit 1
mod_dir="example_module_${BALENA_DEVICE_TYPE}_${OS_VERSION}*"
for each in ${mod_dir}
do
	echo Loading module from "${each}"
	insmod "${each}/hello.ko"
	lsmod | grep hello
	rmmod hello
done
