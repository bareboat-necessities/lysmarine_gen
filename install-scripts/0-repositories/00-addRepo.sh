#!/bin/bash -e

apt-get install -y -q wget gnupg ca-certificates

install -m 0644 -v "$FILE_FOLDER"/free-x.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/debian-backports.list "/etc/apt/sources.list.d/"

wget -q -O - https://www.free-x.de/debian/oss.boating.gpg.key     | apt-key add -

apt-get update  -y -q
apt-get upgrade  -y -q

apt-get -y --no-install-recommends --no-install-suggests install udev/bookworm-backports