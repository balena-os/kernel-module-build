# Kernel Module Build

This is an example of building an out-of-tree kernel module using module headers provided for balena devices.

### Usage

`Dockerfile` demonstrates how to use a multistage build in the balena Cloud to build your kernel and copy it in to your application container. Make sure you change to the desired balenaOS version by amending the environment variables in the Dockerfile.

#### Build options

```
usage: build.sh [build|list] [options]

commands:
  list: list available devices and versions.
  build: build kernel module for specified device and OS versions.

build options:
  --device="$device"    Balena machine name.
  --os-version="$os-version"   Space separated list of OS versions.
  --src="$src"     Where to find kernel module source.
  --dest-dir="$dest-dir"     Destination directory, defaults to "output".

examples:
  ./build.sh list
  ./build.sh build --device intel-nuc --os-version '2.48.0+rev3.prod 2.47.1+rev1.prod' --src example_module
```
