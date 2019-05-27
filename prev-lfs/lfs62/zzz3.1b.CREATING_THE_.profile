#!/bin/bash
# The proper way to start a bash script

timezone='America/Los_Angeles'

echo _________________________________________________________________________________
echo $0
echo =ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae
echo =ae{ Create a \.profile so that date works correctly
echo "    " cat \> \~/.profile \<\< \"EOF\"
echo "    " TZ=$timezone; export TZ
echo "    " EOF
echo "    " source \~/.profile
echo "    " echo \$\(date\)
echo =ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae=ae
echo

cat > ~/.profile << "EOF"
TZ=$timezone; export TZ
EOF
source ~/.profile
echo $(date)
echo =DONE
echo
