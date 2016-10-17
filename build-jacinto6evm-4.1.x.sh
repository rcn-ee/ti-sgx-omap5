#!/bin/bash

ARCH=$(uname -m)
device="jacinto6evm"
branch="ti-img-sgx/1.14.3699939/k4.1"

if [ -f .builddir ] ; then
	if [ -d ./src ] ; then
		rm -rf ./src || true
	fi

	git clone -b ${branch} https://github.com/rcn-ee/ti-omap5-sgx-ddk-linux ./src --depth=1

	x86_dir="/opt/github/bb.org/4.1-normal"
	x86_compiler="gcc-linaro-4.9-2015.05-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-"

	if [ "x${ARCH}" = "xarmv7l" ] ; then
		make_options="CROSS_COMPILE= KERNELDIR=/build/buildd/linux-src TARGET_PRODUCT=${device}"
	else
		make_options="CROSS_COMPILE=/home/voodoo/dl/gcc/${x86_compiler} KERNELDIR=${x86_dir}/KERNEL TARGET_PRODUCT=${device}"
	fi

	cd ./src/eurasia_km/eurasiacon/build/linux2/omap_linux

	make ARCH=arm ${make_options} clean
	make ARCH=arm ${make_options}
fi
#
