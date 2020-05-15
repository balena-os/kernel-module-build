This is an example of building an out-of-tree kernel module using module headers
provided for balena devices.

Make sure you change to the desired balenaOS version in the [Dockerfile.template][Dockerfile template] and commit the change before you start building this project.

#### Usage
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

[Dockerfile template]: https://github.com/balena-io-playground/kernel-module-build/blob/master/Dockerfile.template#L6
