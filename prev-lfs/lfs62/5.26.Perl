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
PkgName=perl-5.8.8
PerlVersion=5.8.8
PkgType=bz2
echo ${PkgName}" "${PkgType}

# unpack
if [[ "${PkgType}" == "gz" ]] ; then
        gunzip ${PkgName}.tar.gz
        tar -xvf ${PkgName}.tar
elif [[ "${PkgType}" == "bz2" ]] ; then
        bzip2 -cd ${PkgName}.tar.bz2 | tar xvf -
fi

# Configure and install
cd ${PkgName}
echo "=> pwd="`pwd`
echo ----------8\<----------8\<----------8\<----------8\<----------8\<----------8\<----------
echo "=> "${0}" "`exec env`
patch -Np1 -i ../${PkgName}-libc-2.patch
./configure.gnu --prefix=/tools -Dstatic_ext='Data/Dumper Fcntl IO POSIX'
# http://linuxfromscratch.org/pipermail/lfs-support/2005-July/027751.html
# Some files are installed read only. For repeating the script you need to:
rm -rf /tools/lib/perl5
make perl utilities
cp -uv perl pod/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/${PerlVersion}
cp -Ruv lib/* /tools/lib/perl5/${PerlVersion}
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
