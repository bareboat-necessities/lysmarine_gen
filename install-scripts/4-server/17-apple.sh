#!/bin/bash -e

# TODO:
exit 0

apt-get -y -q install shairport-sync usbmuxd

install -v -m 0644 "$FILE_FOLDER"/shairport-sync.conf "/etc/"

usermod -aG gpio shairport-sync

systemctl disable shairport-sync # will start it via autostart

install -m 755 -d -o usbmux -g plugdev "/var/lib/usbmux"

install -v -m 0644 "$FILE_FOLDER"/52-carplay.rules "/etc/udev/rules.d/52-carplay.rules"

apt-get clean
