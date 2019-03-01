#!/bin/bash

ARCH=$(uname -m)
device="jacinto6evm"
branch="ti-img-sgx/1.14.3699939/k4.14"
#branch="ti-img-sgx/1.17.4948957/k4.14"

if [ -f .builddir ] ; then
	if [ -d ./src ] ; then
		rm -rf ./src || true
	fi

	git clone -b ${branch} https://github.com/rcn-ee/ti-omap5-sgx-ddk-linux ./src --depth=1
	cd ./src/
	patch -p1 < ../../0001-sgx-add-fno-PIE.patch
	patch -p1 < ../../0003-gcc8.patch
	cd ../

	if [ "x${ARCH}" = "xarmv7l" ] ; then
		make_options="CROSS_COMPILE= KERNELDIR=/build/buildd/linux-src TARGET_PRODUCT=${device}"
	else
		x86_dir="`pwd`/../../normal"
		if [ -f `pwd`/../../normal/.CC ] ; then
			. `pwd`/../../normal/.CC
			make_options="CROSS_COMPILE=${CC} KERNELDIR=${x86_dir}/KERNEL TARGET_PRODUCT=${device}"
		fi
	fi

	cd ./src/eurasia_km/eurasiacon/build/linux2/omap_linux

	make ARCH=arm ${make_options} clean
	echo "make ARCH=arm ${make_options}"
	make ARCH=arm ${make_options}
fi
#
