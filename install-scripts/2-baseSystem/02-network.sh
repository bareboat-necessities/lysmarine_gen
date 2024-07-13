#!/bin/bash -e

# TODO:
exit 0

# Network manager
#apt-get install -y -q network-manager make avahi-daemon bridge-utils wakeonlan #createap

# Resolve coremp135.local
install -v "$FILE_FOLDER"/hostname "/etc/"
cat "$FILE_FOLDER"/hosts >> /etc/hosts

