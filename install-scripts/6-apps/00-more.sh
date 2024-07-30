#!/bin/bash -e

apt-get clean
npm cache clean --force

install -v -m 0755 "$FILE_FOLDER"/bbn-change-password.sh "/usr/local/bin/bbn-change-password"
install -v -m 0755 "$FILE_FOLDER"/bbn-rename-host.sh "/usr/local/sbin/bbn-rename-host"

