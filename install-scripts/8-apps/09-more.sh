#!/bin/bash -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/../lib/common.sh"

apt-get clean
npm cache clean --force || true

apt-get -q -y --no-install-recommends --no-install-suggests install i2c-tools python3-smbus dos2unix \
  traceroute telnet socat gdal-bin openvpn \
  gedit sysstat jq xmlstarlet uhubctl iotop libusb-1.0-0-dev \
  rpi-imager piclone fontconfig gnome-disk-utility xfce4-screenshooter \
  hardinfo baobab # libcanberra-gtk-module

O_DIR=$(pwd)
chmod +x "$FILE_FOLDER"/add-ons/maiana-ais-install.sh
"$FILE_FOLDER"/add-ons/maiana-ais-install.sh
cd $O_DIR

# https://github.com/raspberrypi/usbboot
CUR_DIR="$(pwd)"
mkdir -p /home/user/usbboot && cd /home/user/usbboot
git clone --depth=1 https://github.com/raspberrypi/usbboot
cd usbboot
make -j 5
cp rpiboot /usr/local/sbin/
rm -rf /home/user/usbboot
cd "$CUR_DIR"

systemctl disable openvpn

# rpi-clone
git clone --depth=1 https://github.com/bareboat-necessities/rpi-clone.git
cd rpi-clone
cp rpi-clone rpi-clone-setup /usr/local/sbin
cd ..
chmod +x /usr/local/sbin/rpi-clone*
rm -rf rpi-clone

install -v "$FILE_FOLDER"/piclone.desktop -o 1000 -g 1000 "/home/user/.local/share/applications/piclone.desktop"
install -v "$FILE_FOLDER"/noforeignland.desktop "/usr/local/share/applications/"

apt-get clean
npm cache clean --force || true

install -v -m 0755 "$FILE_FOLDER"/bbn-change-password.sh "/usr/local/bin/bbn-change-password"
install -v -m 0755 "$FILE_FOLDER"/bbn-rename-host.sh "/usr/local/sbin/bbn-rename-host"

install -d -o 1000 -g 1000 -m 0755 "/home/user/add-ons"
chmod +x "$FILE_FOLDER"/add-ons/*.sh
"$FILE_FOLDER"/add-ons/windy-install.sh
"$FILE_FOLDER"/add-ons/lightningmaps-install.sh
"$FILE_FOLDER"/add-ons/marinetraffic-install.sh
"$FILE_FOLDER"/add-ons/boatsetter-install.sh
"$FILE_FOLDER"/add-ons/findacrew-install.sh
"$FILE_FOLDER"/add-ons/noaa-enc-online-install.sh

#install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/timezone-setup.sh "/home/user/add-ons/"
#install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/os-settings.sh "/home/user/add-ons/"
#install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/change-password.sh "/home/user/add-ons/"
#install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/maritime-lib-install.sh "/home/user/add-ons/"
