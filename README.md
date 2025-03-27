# Kernel Module Builder

Provides an example of a multi-container application with a service that builds
an out-of-tree kernel module, loads it and runs it alongside an example service.

* The `load` service builds the kernel module source located in `module/src`
  using module headers provided for balena devices using a multi-stage build
	and then loads the kernel module.

* The `check` service runs a simple entry script that checks for the output of
  the example module and depends on the `load` service above.

## Usage

This project is prepared to build in the balenaCloud builders. To use it
as is [install](https://github.com/balena-io/balena-cli/blob/master/INSTALL.md) the balenaCLI and build with:

```
balena push <fleet>
```

The device type will be automatically retrieved from the specified fleet.

## Customization

* Replace the `OS_VERSION` argument in the `load` service in the
  `docker-compose.yml` file to match the balenaOS version of the target device.

* Replace the contents of the `module/src` directory with the module source to
  build.

* Replace the `check` service by your own service.

* Optionally, kernel header files can be provided under
  `module/kernel-module-headers.tar.gz`. This is only required for
  private device types that do not have the header files publicly available.
