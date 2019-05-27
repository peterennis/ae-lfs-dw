#!/bin/bash
# The proper way to start a bash script

cd ${LFS}/lfs-scripts

set -e -u -x
source ./aeSCRIPT_LIBRARY
trap simple_error ERR

echo
echo _________________________________________________________________________________
echo ${0}
DateAndTime=$(date +%Y_%m_%d_%T)
echo ${DateAndTime}" "${0}" Start $(pwd) - OFF" >> ${LFS}/lfs-logs/logSBU
echo =ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae
echo =ae{ Source the just-created user .bash_profile:
echo =ae{ "        "source \~/.bash_profile
echo =ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae
echo "=>  "completed: source \~/.bash_profile !!!!
echo

echo "=> BEFORE: "${0}" "`exec env`
###source ~/.bash_profile
echo "=> AFTER: "${0}" "`exec env`

DateAndTime=$(date +%Y_%m_%d_%T)
echo ${DateAndTime}" "${0}" End $(pwd)" >> ${LFS}/lfs-logs/logSBU
echo "=>DONE "${0}
echo
