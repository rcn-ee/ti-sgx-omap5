#!/bin/bash

ARCH=$(uname -m)
device="ti335x"
branch="ti-img-sgx/1.17.4948957/k5.4"

if [ -f .builddir ] ; then
	if [ -d ./src ] ; then
		rm -rf ./src || true
	fi

	git clone -b ${branch} https://github.com/rcn-ee/ti-omap5-sgx-ddk-linux ./src --depth=1
	cd ./src/
	echo "patch -p1 < ../../0001-v4.19.x-no-pie.patch"
	patch -p1 < ../../0001-v4.19.x-no-pie.patch
	git diff
	cd ../

	if [ "x${ARCH}" = "xarmv7l" ] ; then
		make_options="TARGET_PRIMARY_ARCH=target_armhf CROSS_COMPILE= KERNELDIR=/build/buildd/linux-src TARGET_PRODUCT=${device}"
	else
		x86_dir="`pwd`/../../normal"
		if [ -f `pwd`/../../normal/.CC ] ; then
			. `pwd`/../../normal/.CC
			make_options="TARGET_PRIMARY_ARCH=target_armhf CROSS_COMPILE=${CC} KERNELDIR=${x86_dir}/KERNEL TARGET_PRODUCT=${device}"
		fi

#		x86_dir="`pwd`/../../rt"
#		if [ -f `pwd`/../../rt/.CC ] ; then
#			. `pwd`/../../rt/.CC
#			make_options="CROSS_COMPILE=${CC} KERNELDIR=${x86_dir}/KERNEL TARGET_PRODUCT=${device}"
#		fi
	fi

	cd ./src/eurasia_km/eurasiacon/build/linux2/omap_linux

	make ARCH=arm ${make_options} clean
	echo "make ARCH=arm ${make_options}"
	make ARCH=arm ${make_options}
fi
#
