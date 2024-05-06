#!/bin/bash

#https://git.ti.com/gitweb?p=arago-project/meta-ti.git;a=tree;f=recipes-bsp/powervr-drivers;hb=refs/heads/dunfell

ARCH=$(uname -m)
device="j721e"
#branch="1.13-5776728/linux-k5.10"
branch="linuxws/dunfell/k5.10/1.15.6133109_unified_fw_pagesize"

#  LD [M]  /opt/github/bb.org/5.10.x/ti-sgx-omap5/src/src/binary_j721e_linux_wayland_release/target_aarch64/kbuild/pvrsrvkm.ko

if [ -f .builddir ] ; then
	if [ -d ./src ] ; then
		rm -rf ./src || true
	fi

	echo "git clone -b ${branch} https://github.com/rcn-ee/ti-img-rogue-driver ./src --depth=1"
	git clone -b ${branch} https://github.com/rcn-ee/ti-img-rogue-driver ./src --depth=1
	cd ./src/
	echo "patch -p1 < ../../0001-buildvars.mk-add-fno-PIE.patch"
	patch -p1 < ../../0001-buildvars.mk-add-fno-PIE.patch

	#branch="1.13-5776728/linux-k5.10"
	#echo "patch -p1 < ../../0002-j721e_linux-disable-SUPPORT_MIPS_64K_PAGE_SIZE.patch"
	#patch -p1 < ../../0002-j721e_linux-disable-SUPPORT_MIPS_64K_PAGE_SIZE.patch

	git diff
	cd ../

	PVR_SOC=j721e_linux
	PVR_BUILD=release
	PVR_WS=wayland
	if [ "x${ARCH}" = "xaarch64" ] ; then
		make_options="CROSS_COMPILE=aarch64-linux-gnu- KERNELDIR=/build/buildd/linux-src RGX_BVNC=22.104.208.318 BUILD=${PVR_BUILD} PVR_BUILD_DIR=${PVR_SOC} WINDOW_SYSTEM=${PVR_WS}"
	else
		x86_dir="`pwd`/../../normal-arm64"
		if [ -f `pwd`/../../normal-arm64/.CC ] ; then
			. `pwd`/../../normal-arm64/.CC
			make_options="CROSS_COMPILE=aarch64-linux-gnu- KERNELDIR=${x86_dir}/KERNEL RGX_BVNC=22.104.208.318 BUILD=${PVR_BUILD} PVR_BUILD_DIR=${PVR_SOC} WINDOW_SYSTEM=${PVR_WS}"
		fi

#		x86_dir="`pwd`/../../rt"
#		if [ -f `pwd`/../../rt/.CC ] ; then
#			. `pwd`/../../rt/.CC
#			make_options="CROSS_COMPILE=${CC} KERNELDIR=${x86_dir}/KERNEL TARGET_PRODUCT=${device}"
#		fi
	fi

	#exit 2
	cd ./src/build/linux/j721e_linux
	make ARCH=arm64 ${make_options} clean
	echo "make ARCH=arm64 ${make_options}"
	make ARCH=arm64 ${make_options}
fi
#
