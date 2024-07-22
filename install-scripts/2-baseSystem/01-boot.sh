#!/bin/bash -e

apt-get install -y -q parted gdisk telnet socat traceroute

if [ -f /etc/issue ] ; then
  install -m0664 -v "$FILE_FOLDER"/ascii_logo.txt "/etc/issue"
fi

if [ -f /usr/local/m5stack/init.sh ] ; then
  install -m0644 -v "$FILE_FOLDER"/bbn_logo.jpg "/usr/local/m5stack/bbn_logo.jpg"
  sed -i "s#m5stack/logo.jpg#m5stack/bbn_logo.jpg#g" /usr/local/m5stack/init.sh
fi

sed -i 's#\[ "$1" == "stop" \]#[ "z\$1" == "zstop" ]#' /etc/rc.local

# see https://github.com/m5stack/CoreMP135_buildroot-external-st/issues/8
systemctl disable getty@ttyGS0.service
install -m 644 "$FILE_FOLDER"/usb-otg-state.path "/lib/systemd/system/usb-otg-state.path"
install -m 644 "$FILE_FOLDER"/usb-otg-state.service "/lib/systemd/system/usb-otg-state.service"
systemctl enable usb-otg-state.path
