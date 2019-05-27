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
PkgName=flex-2.5.33
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
./configure --prefix=/usr
make
# To test the results, issue:
make check
make install
ln -svf libfl.a /usr/lib/libl.a
# A few programs do not know about flex yet and try to run its predecessor, lex.
# To support those programs, create a wrapper script named lex that calls flex in 
# lex emulation mode:
cat > /usr/bin/lex << "EOF"
#!/bin/sh
# Begin /usr/bin/lex

exec /usr/bin/flex -l "$@"

# End /usr/bin/lex
EOF
chmod -v 755 /usr/bin/lex
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
