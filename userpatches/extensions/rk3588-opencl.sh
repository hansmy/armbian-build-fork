## Extension work for setting up OpenCL on a minimalist RK3588 kernel

function extension_prepare_config__install_minimal_rk3588_opencl() {

	# Silently deny old releases which are not supported but are still in the system
	[[ "${RELEASE}" =~ ^(bookworm|bullseye|buster|focal|jammy)$ ]] && return 0

	# Deny on non-minimal CLI images
	if [[ "${BUILD_MINIMAL}" != "yes" ]]; then
		display_alert "Extension: ${EXTENSION}" "skip installation in non-minimal images" "warn"
		return 0
	fi

    ## This is incompatible with the mesa-vpu extension, and should probably yell if 
    ## both are attempted. The tell is panthor. OpenCL/Mali and panthor are incompatible.
    ## We should similarly yell if we don't find this is a vendor branch build.

	# # This should be enabled on all for rk3588 distributions where mesa and vendor kernel is present
	# if [[ "${LINUXFAMILY}" =~ ^(rockchip-rk3588|rk35xx)$ && "$BRANCH" == vendor ]]; then
	# 	if [[ -n $DEFAULT_OVERLAYS ]]; then
	# 		DEFAULT_OVERLAYS+=" panthor-gpu"
	# 	else
	# 		declare -g DEFAULT_OVERLAYS="panthor-gpu"
	# 	fi
	# fi
}


## Ultimately, this is where we get the blobs, which are only truly compatible with the vendor branch.

function post_install_kernel_debs__install_minimal_rk3588_opencl() {

	# Silently deny old releases which are not supported but are still in the system
	[[ "${RELEASE}" =~ ^(bookworm|bullseye|buster|focal|jammy)$ ]] && return 0

	# Deny on non-minimal CLI images
	if [[ "${BUILD_MINIMAL}" != "yes" ]]; then
		display_alert "Extension: ${EXTENSION}" "skip installation in non-minimal images" "warn"
		return 0
	fi

	declare -a pkgs=("libdrm2")
	pkgs+=("libdrm-common")
	pkgs+=("clinfo")
	pkgs+=("mesa-opencl-icd")
	pkgs+=("opencl-c-headers")
	pkgs+=("ocl-icd-opencl-dev")

    local mali_driver_url="https://github.com/ginkage/libmali-rockchip/releases/download/v1.9-1-4b399ed/libmali-valhall-g610-g24p0-dummy_1.9-1_arm64.deb"
	local file_name="/tmp/${mali_driver_url##*/}"

	display_alert "Extension: ${EXTENSION}" "downloading ${mali_driver_url} to ${file_name}" "warn"

	## Download the driver bundle package
	use_clean_environment="yes" chroot_sdcard "wget ${mali_driver_url} -P /tmp"

	## Add it to the install command as a file
	pkgs+=("${file_name}")

	## Do the install
	use_clean_environment="yes" chroot_sdcard_apt_get_install "${pkgs[@]}"

	## Remove the downloaded driver package
 	use_clean_environment="yes" chroot_sdcard rm -f "${file_name}"
}
