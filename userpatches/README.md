# User patches for Armbian building

This is designed to set up a deployable Armbian variant including OpenCL, Mali
support, and everything else we need for our system deployments. Generally we
want an embeddable system, so it will typically be minimal (i.e., no desktop, no
applications) and with enough boot configuration to set up what we need for
testing.

This is not a production deployment. It is still a full Linux, with a package
system, updates, and everything. For development, that is what we need. For
production, we need to lock all that down. Having a solid image that includes
all the components we need is a good start to that.

## Commands:

A typical build command is:

```bash
./compile.sh \
    BOARD=rock-5b-plus \
    BRANCH=current \
    RELEASE=noble \
    NETWORKING_STACK=systemd-networkd \
    BUILD_MINIMAL=yes \
    KERNEL_CONFIGURE=no \
    KERNEL_GIT=full \
    build
```

## Outstanding tasks:

- [ ] Add ssh keys to allow remote connections
- [ ] Verify `armbianEnv.txt`
- [ ] Install the appropriate packages, OpenCL, etc.
- [ ] Testing

## Notes

gstreamer is a potential issue, depending on whether we need to build for WebRTC
or not. For most purposes, standard gstreamer is fine, and probably simpler.
However, we are then coupled to the system gstreamer. And WebRTC requires
components that are not standard. So we will likely need to clean build the
components that we do need. 

In a related way, OpenCV will also be required, but again, we do not actually
need OpenCV in production. However, we use it extensively in testing.

For deploying OpenCL, the `mesa-vpu` extension is a good place to start. It is
not what we need, but it is close. 
