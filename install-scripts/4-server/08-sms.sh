#!/bin/bash -e

apt-get clean
rm -rf /.cache/pip

apt-get -y -q install ppp usb-modeswitch usb-modeswitch-data gammu


