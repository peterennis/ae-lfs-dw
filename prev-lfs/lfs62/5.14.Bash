#!/bin/bash
# The proper way to start a bash script

cd ${LFS}/lfs-scripts
echo "=> pwd="`pwd`

set -e -u -x
source ./aeSCRIPT_LIBRARY
trap simple_error ERR

cd ${LFS}/sources
echo "=> pwd="`pwd`

echo
echo _________________________________________________________________________________
echo ${0}
DateAndTime=$(date +%Y_%m_%d_%T)
echo ${DateAndTime}" "${0}" Start $(pwd)" >> ${LFS}/lfs-logs/logSBU

# Set a variable for the package name
PkgName=bash-3.1
PkgType=gz
echo ${PkgName}" "${PkgType}

# unpack
if [[ "${PkgType}" == "gz" ]] ; then
        gzip -cd ${PkgName}.tar.gz | tar xvf -
elif [[ "${PkgType}" == "bz2" ]] ; then
        bzip2 -cd ${PkgName}.tar.bz2 | tar xvf -
fi

# Configure and install
cd ${PkgName}
echo "=> pwd="`pwd`
echo ----------8\<----------8\<----------8\<----------8\<----------8\<----------8\<----------
echo "=> "${0}" "`exec env`
patch -Np1 -i ../${PkgName}-fixes-8.patch
./configure --prefix=/tools --without-bash-malloc
make
# To run the tests
#make tests
make install

link=/tools/bin/sh
echo "=> \${link}="${link}
if [[ -L ${link} ]] ; then
        echo "=> The link "${link}" exists."
        echo "=> The breakpoint is included because the link exists."
        ls -l ${link}
else
	ln -vs bash /tools/bin/sh
fi
echo ----------\>8----------\>8----------\>8----------\>8----------\>8----------\>8----------

# Remove the extracted source files and the compile directory
echo
cd ${LFS}/sources
echo "=> pwd="`pwd`
rm -rf ${PkgName}
echo "=> Removed directory "${PkgName}
echo "=> Show a reverse sort list of \${LFS}/tools/bin:"
ls -ltr ${LFS}/tools/bin
DateAndTime=$(date +%Y_%m_%d_%T)
echo ${DateAndTime}" "${0}" End $(pwd)" >> ${LFS}/lfs-logs/logSBU
echo "=>DONE "${0}
echo
