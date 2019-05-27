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
PkgName=tcl8.4.13
PkgType=gz
TclLink=tclsh8.4
echo ${PkgName}" "${PkgType}

# unpack
if [[ "${PkgType}" == "gz" ]] ; then
        gzip -cd ${PkgName}-src.tar.gz | tar xvf -
elif [[ "${PkgType}" == "bz2" ]] ; then
        bzip2 -cd ${PkgName}.tar.bz2 | tar xvf -
fi

# Configure and install
cd ${PkgName}
echo "=> pwd="`pwd`
echo ----------8\<----------8\<----------8\<----------8\<----------8\<----------8\<----------
echo "=> "${0}" "`exec env`
cd unix
echo "=> pwd="`pwd`
./configure --prefix=/tools
make
#TZ=UTC make test
make install
make install-private-headers

link=/tools/bin/tclsh
echo "=> \${link}="${link}
if [[ -L ${link} ]] ; then
        echo "=> The link "${link}" exists."
        echo "=> The breakpoint is included because the link exists."
        ls -l ${link}
else
	ln -s ${TclLink} /tools/bin/tclsh
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
