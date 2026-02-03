#!/bin/bash -e

install -d -o 1000 -g 1000 -m 0755 "/home/user/add-ons"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/hot-fixes-install.sh "/home/user/add-ons/"

apt-get install -y libavahi-compat-libdnssd-dev libsqlite3-0
