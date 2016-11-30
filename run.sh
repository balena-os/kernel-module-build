#!/bin/bash

insmod example_module/hello.ko
lsmod | grep hello
rmmod hello
echo done!

while true; do
	sleep 60
done
