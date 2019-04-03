#!/bin/bash -e

install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/.pypilot"
install -v -o 1000 -g 1000 files/signalk.conf "${ROOTFS_DIR}/home/pi/.pypilot/"


on_chroot << EOF
  pip install ujson
EOF

on_chroot << EOF

  git clone https://github.com/seandepagnier/RTIMULib2
  cd RTIMULib2/Linux/python
  python setup.py build
  python setup.py install
  cd ../../
  rm -rf /RTIMULib2

  echo " Pypilot : "

  cd /
  git clone https://github.com/pypilot/pypilot.git
  cd pypilot
  python setup.py install
  cd scripts/debian/
  cp -r etc/systemd/system/* /etc/systemd/system/
  cd /
  rm -rf pypilot


EOF