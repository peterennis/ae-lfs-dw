#!/bin/bash
# The proper way to start a bash script

set -e -u -x
source ./aeSCRIPT_LIBRARY
trap simple_error ERR

cd /sources
echo "=> pwd="`pwd`

echo
echo _________________________________________________________________________________
echo ${0}
DateAndTime=$(date +%Y_%m_%d_%T)
echo ${DateAndTime}" "${0}" Start $(pdw)" >> /lfs-logs/logSBU

# Set variables for the package name and type
PkgName=perl-5.8.8
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
echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
./configure.gnu --prefix=/usr \
    -Dman1dir=/usr/share/man/man1 \
    -Dman3dir=/usr/share/man/man3 \
    -Dpager="/usr/bin/less -isR"
make
make test
make install
echo ----------\>8----------\>8----------\>8----------\>8----------\>8----------\>8----------

# Remove the extracted source files and the compile directory
echo
cd /sources
echo "=> pwd="`pwd`
rm -rf ${PkgName}
echo "=> Removed directory "${PkgName}

DateAndTime=$(date +%Y_%m_%d_%T)
echo ${DateAndTime}" "${0}" End $(pwd)" >> /lfs-logs/logSBU
echo "=>DONE "${0}
echo
