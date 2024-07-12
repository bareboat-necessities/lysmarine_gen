#!/bin/bash -e

#TODO
exit 0

apt-get -y -q install wvdial ppp picocom slurm python3-pip

if [ "$LMARCH" == 'armhf' ]; then
  apt-get -y -q install pppstatus
fi

# See: http://newt.phys.unsw.edu.au/~mcba/iridiumLinux.html
install -v -m 0644 "$FILE_FOLDER"/wvdial-iridium.conf "/etc/"

# See https://github.com/tdolby/python-iridium-modem/
pip3 install python-iridium-modem
