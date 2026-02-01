#!/bin/bash -e

# See https://pypi.org/project/ttspico/

wget -q -O - https://ftp-master.debian.org/keys/release-11.asc | sudo apt-key add -

echo "deb http://deb.debian.org/debian trixie non-free" | sudo tee "/etc/apt/sources.list"

sudo apt update
sudo apt-get -y install libttspico-utils
sudo apt-get -y install sox
