#!/bin/bash -e

ARCH=$(uname -m)

if [ "x${ARCH}" = "xarmv7l" ] ; then
	uname_r="VERSION"
	distro="DISTRO"
	dpkg_arch="armhf"
else
	uname_r="4.1.10-ti-r21.2"
	distro="jessie"
	dpkg_arch="amd64"
fi

package="ti-sgx"
base_dir="./"

device="5430"

if [ -f ${base_dir}/src/eurasia_km/eurasiacon/binary2_omap${device}_linux_release/target/kbuild/omapdrm_pvr.ko ] ; then

	#modules
	cp -v ${base_dir}/src/eurasia_km/eurasiacon/binary2_omap${device}_linux_release/target/kbuild/omapdrm_pvr.ko ${base_dir}
#	cp -v ${base_dir}/src/gfx_rel_${device}.x/omaplfb.ko ${base_dir}
#	cp -v ${base_dir}/src/gfx_rel_${device}.x/bufferclass_ti.ko ${base_dir}

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
	echo "Files: omapdrm_pvr.ko /lib/modules/${uname_r}/extra/${device}/" >> ${base_dir}control
#	echo " omaplfb.ko /lib/modules/${uname_r}/extra/${device}/" >> ${base_dir}control
#	echo " bufferclass_ti.ko /lib/modules/${uname_r}/extra/${device}/" >> ${base_dir}control
	echo "Description: ${package} modules" >> ${base_dir}control
	echo " Kernel modules for ${package} devices" >> ${base_dir}control
	echo "" >> ${base_dir}control

	equivs-build control

	rm -rf omapdrm_pvr.ko || true
	rm -rf README || true
	rm -rf MIT-COPYING || true
	rm -rf control || true

fi
