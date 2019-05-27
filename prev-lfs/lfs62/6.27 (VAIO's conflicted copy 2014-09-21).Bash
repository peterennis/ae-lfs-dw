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
echo ${DateAndTime}" "${0}" Start $(pwd)" >> /lfs-logs/logSBU

# Set variables for the package name and type
PkgName=bash-3.1
PkgType=gz
SecondaryPkgName=bash-doc-3.1
echo ${PkgName}" "${PkgType}" "${SecondaryPkgName}

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
tar -xvf ../${SecondaryPkgName}.tar.gz &&
sed -i "s|htmldir = @htmldir@|htmldir = /usr/share/doc/bash-3.1|" \
    Makefile.in
patch -Np1 -i ../${PkgName}-fixes-8.patch
./configure --prefix=/usr --bindir=/bin \
    --without-bash-malloc --with-installed-readline
make
make tests
make install
# Run the newly compiled bash program - replacing the one that is currently being executed:
# NOTE: This will happen when the script is run the second time \?\?\?. For the auto scripting
# the exec will stop the process.
#exec /bin/bash --login +h
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
