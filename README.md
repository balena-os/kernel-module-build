# Nvidia Kernel Module Builder

Provides a multi-container application with a service that builds
an out-of-tree Nvidia kernel module, loads it and runs it alongside an example service.

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

## Note
Once pushed, the Nvidia drivers will be loaded.
To confirm they are properly working you can SSH to the any device and run:
`lsmod | grep nvidia`

To push this container again you will first need to unload any previous module:
`rmmod nvidia_drm nvidia_uvm nvidia_modeset nvidia_peermem nvidia`
