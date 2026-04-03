# User patches for Armbian building

This is designed to set up a deployable Armbian variant including OpenCL, Mali
support, and everything else we need for our system deployments. Generally we
want an embeddable system, so it will typically be minimal (i.e., no desktop, no
applications) and with enough boot configuration to set up what we need for
testing.

This is not a production deployment. It is still a full Linux. 

## Commands:

A typical build command is:

```bash
./compile.sh \
    BOARD=rock-5b-plus \
    BRANCH=current \
    RELEASE=noble \
    NETWORKING_STACK=systemd-networkd \
    BUILD_MINIMAL=yes \
    KERNEL_GIT=full \
    build
```
