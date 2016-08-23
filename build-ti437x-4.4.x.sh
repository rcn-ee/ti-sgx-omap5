#!/bin/bash

ARCH=$(uname -m)
device="ti437x"
branch="ti-img-sgx/1.14.3699939/k4.4"

if [ -f .builddir ] ; then
	if [ -d ./src ] ; then
		rm -rf ./src || true
	fi

	git clone -b ${branch} https://github.com/rcn-ee/ti-omap5-sgx-ddk-linux ./src --depth=1

	x86_dir="/opt/github/bb.org/ti-4.4/normal"
	x86_compiler="gcc-linaro-4.9-2016.02-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-"

	if [ "x${ARCH}" = "xarmv7l" ] ; then
		make_options="CROSS_COMPILE= KERNELDIR=/build/buildd/linux-src"
	else
		make_options="CROSS_COMPILE=/home/voodoo/dl/gcc/${x86_compiler} KERNELDIR=${x86_dir}/KERNEL"
	fi

	cd ./src/eurasia_km/eurasiacon/build/linux2/omap_linux

	make ARCH=arm ${make_options} clean
	make ARCH=arm ${make_options}
fi
#
