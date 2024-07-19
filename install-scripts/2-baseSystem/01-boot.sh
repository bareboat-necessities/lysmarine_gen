#!/bin/bash -e

apt-get install -y -q parted gdisk telnet

if [ -f /etc/issue ] ; then
  install -m0664 -v "$FILE_FOLDER"/ascii_logo.txt "/etc/issue"
fi

if [ -f /usr/local/m5stack/init.sh ] ; then
  install -m0644 -v "$FILE_FOLDER"/bbn_logo.jpg "/usr/local/m5stack/bbn_logo.jpg"
  sed -i "s#m5stack/logo.jpg#m5stack/bbn_logo.jpg#g" /usr/local/m5stack/init.sh
fi

