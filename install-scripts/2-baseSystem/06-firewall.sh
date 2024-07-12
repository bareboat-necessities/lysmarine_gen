#!/bin/bash -e

apt-get -y -q install ufw

# will be called on first boot
install -m 755 "$FILE_FOLDER"/ufw-init.sh "/usr/local/sbin/ufw-init"
