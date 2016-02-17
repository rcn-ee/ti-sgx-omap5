#!/bin/bash -e

ARCH=$(uname -m)

if [ "x${ARCH}" = "xarmv7l" ] ; then
	uname_r="VERSION"
	distro="DISTRO"
	dpkg_arch="armhf"
else
	uname_r="4.1.18-ti-r48.3"
	distro="jessie"
	dpkg_arch="amd64"
fi

package="ti-sgx"
base_dir="./"

device="jacinto6evm"

if [ -f ${base_dir}/src/eurasia_km/eurasiacon/binary2_omap_linux_release/target/kbuild/pvrsrvkm.ko ] ; then

	#modules
	cp -v ${base_dir}/src/eurasia_km/eurasiacon/binary2_omap_linux_release/target/kbuild/pvrsrvkm.ko ${base_dir}
	cp -v ${base_dir}/src/eurasia_km/eurasiacon/binary2_omap_linux_release/target/kbuild/bc_example.ko ${base_dir}

	#readme
	cp -v ${base_dir}/src/eurasia_km/README ${base_dir}
	cp -v ${base_dir}/src/eurasia_km/MIT-COPYING ${base_dir}

	echo "Section: misc" > ${base_dir}control
	echo "Priority: optional" >> ${base_dir}control
	echo "Homepage: https://github.com/rcn-ee/${package}-omap5" >> ${base_dir}control
	echo "Standards-Version: 3.9.6" >> ${base_dir}control
	echo "" >> ${base_dir}control
	echo "Package: ${package}-${device}-modules-${uname_r}" >> ${base_dir}control
	echo "Version: 1${distro}" >> ${base_dir}control
	echo "Pre-Depends: linux-image-${uname_r}" >> ${base_dir}control
	echo "Depends: linux-image-${uname_r}" >> ${base_dir}control
	echo "Maintainer: Robert Nelson <robertcnelson@gmail.com>" >> ${base_dir}control
	echo "Architecture: ${dpkg_arch}" >> ${base_dir}control
	echo "Copyright: MIT-COPYING" >> ${base_dir}control
	echo "Readme: README" >> ${base_dir}control
	echo "Files: pvrsrvkm.ko /lib/modules/${uname_r}/extra/${device}/" >> ${base_dir}control
	echo " bc_example.ko /lib/modules/${uname_r}/extra/${device}/" >> ${base_dir}control
	echo "Description: ${package} modules" >> ${base_dir}control
	echo " Kernel modules for ${package} devices" >> ${base_dir}control
	echo "" >> ${base_dir}control

	equivs-build control

	rm -rf pvrsrvkm.ko || true
	rm -rf bc_example.ko || true
	rm -rf README || true
	rm -rf MIT-COPYING || true
	rm -rf control || true

fi
