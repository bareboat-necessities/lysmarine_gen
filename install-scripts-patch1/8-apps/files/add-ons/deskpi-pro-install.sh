#!/bin/bash -e

# See: https://github.com/DeskPi-Team/deskpi

cd ~
git clone https://github.com/DeskPi-Team/deskpi.git
cd ~/deskpi/

myArch=$(dpkg --print-architecture)

if [ "armhf" != "$myArch" ] ; then
  chmod +x install.sh
  sudo ./install.sh
else
  chmod +x install-raspios-64bit.sh
  sudo ./install-raspios-64bit.sh
fi
