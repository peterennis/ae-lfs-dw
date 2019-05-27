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
PkgName=vim-7.0
PkgDir=vim70
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
cd ${PkgDir}
echo "=> pwd="`pwd`
echo ----------8\<----------8\<----------8\<----------8\<----------8\<----------8\<----------
echo "=> "${0}" "`exec env`
patch -Np1 -i ../${PkgName}-fixes-7.patch
patch -Np1 -i ../${PkgName}-mandir-1.patch
patch -Np1 -i ../${PkgName}-spellfile-1.patch
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr --enable-multibyte
make
# To test the results, issue: make test. However, this test suite outputs a lot of binary data to the screen, which can cause issues with the settings of the current terminal. This can be resolved by redirecting the output to a log file.
make test > vimtest.log
make install
rm -f /usr/share/vim/${PkgDir}/tutor/tutor.{gr,pl,ru,sk}
rm -f /usr/share/vim/${PkgDir}/tutor/tutor.??.*
ln -svf vim /usr/bin/vi
for L in "" fr it pl ru; do
    ln -svf vim.1 /usr/share/man/$L/man1/vi.1
done
ln -svf ../vim/${PkgDir}/doc /usr/share/doc/${PkgName}
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
syntax on
if (&term == "iterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
# Documentation for other available options can be obtained by running the following command:
#vim -c ':options'
#To install spell files for your preferred language, download the *.spl  and optionally,
#the *.sug files for your language and character encoding from
#ftp://ftp.vim.org/pub/vim/runtime/spell/
#and save them to /usr/share/vim/vim70/spell/.
#To use these spell files, some configuration in /etc/vimrc is needed, e.g.:
#set spelllang=en,ru
#set spell
echo ----------\>8----------\>8----------\>8----------\>8----------\>8----------\>8----------

# Remove the extracted source files and the compile directory
echo
cd /sources
echo "=> pwd="`pwd`
rm -rf ${PkgDir}
echo "=> Removed directory "${PkgDir}

DateAndTime=$(date +%Y_%m_%d_%T)
echo ${DateAndTime}" "$0" End $(pwd)" >> /lfs-logs/logSBU
echo "=>DONE "${0}
echo
