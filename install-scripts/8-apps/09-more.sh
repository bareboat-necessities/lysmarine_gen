#!/bin/bash -e

apt-get clean
npm cache clean --force

if [ "$BBN_KIND" == "LITE" ] ; then
  apt-get -q -y --no-install-recommends --no-install-suggests install i2c-tools python3-smbus dos2unix \
    traceroute telnet socat \
    sysstat jq xmlstarlet uhubctl iotop libusb-1.0-0-dev
else
  apt-get -q -y --no-install-recommends --no-install-suggests install i2c-tools python3-smbus dos2unix \
    traceroute telnet socat  \
    python3-gpiozero libusb-1.0-0-dev \
    sysstat jq xmlstarlet uhubctl iotop rsync timeshift at
fi

systemctl disable openvpn

apt-get clean
npm cache clean --force

install -v -m 0755 "$FILE_FOLDER"/bbn-change-password.sh "/usr/local/bin/bbn-change-password"
install -v -m 0755 "$FILE_FOLDER"/bbn-rename-host.sh "/usr/local/sbin/bbn-rename-host"

chmod +x "$FILE_FOLDER"/add-ons/*.sh
"$FILE_FOLDER"/add-ons/windy-install.sh
"$FILE_FOLDER"/add-ons/lightningmaps-install.sh
"$FILE_FOLDER"/add-ons/marinetraffic-install.sh
"$FILE_FOLDER"/add-ons/boatsetter-install.sh
"$FILE_FOLDER"/add-ons/findacrew-install.sh
"$FILE_FOLDER"/add-ons/noaa-enc-online-install.sh

install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/timezone-setup.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/change-password.sh "/home/user/add-ons/"

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

install -v -o 1000 -g 1000 -m 0644 "$FILE_FOLDER"/add-ons/readme.txt "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/text-to-speech-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/text-to-speech-sample.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/navionics-demo-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/boatsetter-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/lightningmaps-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/marinetraffic-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/windy-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/findacrew-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/tripwire-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/noaa-enc-online-install.sh "/home/user/add-ons/"
