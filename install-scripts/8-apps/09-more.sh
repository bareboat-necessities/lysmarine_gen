#!/bin/bash -e

apt-get clean
npm cache clean --force || true

if [ "$BBN_KIND" == "LITE" ] ; then
  apt-get -q -y --no-install-recommends --no-install-suggests install i2c-tools python3-smbus dos2unix \
    traceroute telnet socat gdal-bin openvpn \
    gedit sysstat jq xmlstarlet uhubctl iotop libusb-1.0-0-dev \
    rpi-imager piclone fontconfig gnome-disk-utility xfce4-screenshooter \
    hardinfo baobab # libcanberra-gtk-module
else
  apt-get -q -y --no-install-recommends --no-install-suggests install i2c-tools python3-smbus dos2unix \
    traceroute telnet whois socat gdal-bin openvpn seahorse inxi \
    dconf-editor gedit gnome-calculator \
    python3-gpiozero libusb-1.0-0-dev \
    sysstat jq xmlstarlet uhubctl iotop rsync timeshift at \
    rpi-imager piclone fontconfig gnome-disk-utility xfce4-screenshooter catfish \
    hardinfo baobab # libcanberra-gtk-module restic gnome-chess openpref nautic foxtrotgps
fi

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

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

# TODO: disabled temp
#pip3 install adafruit-ampy

install -v -o 1000 -g 1000 -m 0644 "$FILE_FOLDER"/add-ons/readme.txt "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/deskpi-pro-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/text-to-speech-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/text-to-speech-sample.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/wxtoimg-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/sdrglut-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/pactor-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/nmea-sleuth-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/qtvlm-install.sh "/home/user/add-ons/"
#install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/predict-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/calibrate-touchscreen.sh "/home/user/add-ons/"
#install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/scytalec-inmarsat-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/winlink-pat-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/argonOne-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/navionics-demo-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/widevine-lib-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/wifi-drivers-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/boatsetter-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/lightningmaps-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/marinetraffic-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/windy-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/ads-b-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/tvheadend-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/dvb-t-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/findacrew-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/homeassistant-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/jellyfin-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/stdc-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/sailorhat-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/maiana-ais-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/tripwire-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/noaa-enc-online-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/add-ons/xtide-install.sh "/home/user/add-ons/"


install -v "$FILE_FOLDER"/bbn-checklist.desktop "/usr/local/share/applications/"

install -d -m 0755 "/usr/local/share/colreg"
curl 'https://en.wikisource.org/api/rest_v1/page/pdf/International_Regulations_for_Preventing_Collisions_at_Sea' \
 -H 'Accept: */*;q=0.8' \
 -H 'Accept-Language: en-US,en;q=0.5' --compressed \
 -H 'DNT: 1' -H 'Connection: keep-alive' \
 -H 'Upgrade-Insecure-Requests: 1' -H 'TE: Trailers' \
 --output "/usr/local/share/colreg/colreg.pdf"
install -v "$FILE_FOLDER"/colreg.desktop "/usr/local/share/applications/"

#install -d -m 0755 "/usr/local/share/knots"
#install -v -m 0644 "$FILE_FOLDER"/knots/knots.html "/usr/local/share/knots/"
#install -v -m 0644 "$FILE_FOLDER"/knots/knots.svg "/usr/local/share/knots/"
#install -v -m 0644 "$FILE_FOLDER"/knots/License_free.txt "/usr/local/share/knots/"
#install -v "$FILE_FOLDER"/knots.desktop "/usr/local/share/applications/"

install -d -o 1000 -g 1000 -m 0755 "/home/user/FloatPlans"

install -d '/usr/local/share/marine-life'
install -v -m 0644 "$FILE_FOLDER"/marine-life-id.html "/usr/local/share/marine-life/"
install -v "$FILE_FOLDER"/marine-life.desktop "/usr/local/share/applications/"

install -d -o 1000 -g 1000 -m 0755 "/home/user/.vessel"
install -v -o 1000 -g 1000 -m 0644 "$FILE_FOLDER"/vessel.data "/home/user/.vessel/"
install -v -m 0755 "$FILE_FOLDER"/vessel-data.sh "/usr/local/bin/vessel-data"
install -v "$FILE_FOLDER"/vessel-data.desktop "/usr/local/share/applications/"

if [ "$LMARCH" == 'arm64' ]; then
  wget https://github.com/rclone/rclone/releases/download/v1.65.0/rclone-v1.65.0-linux-arm64.deb
  dpkg -i rclone-v1.65.0-linux-arm64.deb
  rm rclone-v1.65.0-linux-arm64.deb
fi

#install -v "$FILE_FOLDER"/term-weather.desktop "/usr/local/share/applications/"

git clone --depth=1 https://github.com/formatc1702/WireViz
cd WireViz/
python3 setup.py install
cd .. && rm -rf WireViz/
