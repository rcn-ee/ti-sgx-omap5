#!/bin/bash

ARCH=$(uname -m)

if [ -d ./src ] ; then
	rm -rf ./src || true
fi

#ARCH=arm
#CROSS_COMPILE=arm-linux-gnueabi-hf-
#KERNELDIR=<your kernel directory>
#DISCIMAGE=<kernel module installation path>

git clone -b dra7/k4.1 git://git.ti.com/graphics/omap5-sgx-ddk-linux.git ./src --depth=1

x86_dir="/opt/github/bb.org/ti-4.1/normal"
x86_compiler="gcc-linaro-4.9-2015.02-3-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-"

if [ "x${ARCH}" = "xarmv7l" ] ; then
	make_options="CROSS_COMPILE= KERNELDIR=/build/buildd/linux-src want_xorg=1 SUPPORT_DRI_DRM_EXTERNAL=0 LDM_PLATFORM=1"
else
	make_options="CROSS_COMPILE=${x86_dir}/dl/${x86_compiler} KERNELDIR=${x86_dir}/KERNEL want_xorg=1 SUPPORT_DRI_DRM_EXTERNAL=0 LDM_PLATFORM=1"
fi

cd ./src/eurasia_km/eurasiacon/build/linux2/omap5430_linux

make ARCH=arm ${make_options} clean
make ARCH=arm ${make_options}
#
