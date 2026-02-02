#!/bin/bash -e

rm -rf  /tmp/empty-cache46

apt-get remove -y --purge greybird-gtk-theme murrine-themes # rpd-icons

apt-get -y autoremove --purge

apt-get clean
npm cache clean --force

# remove python pip cache
rm -rf ~/.cache/pip

# remove all cache
rm -rf ~/.cache
rm -rf ~/.config
rm -rf ~/.npm
rm -rf ~/.wget*

