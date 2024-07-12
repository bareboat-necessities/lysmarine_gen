#!/bin/bash -e

AGENT="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"

apt-get -q -y --no-install-recommends --no-install-suggests install libusb-0.1-4 libusb-1.0-0 \
  mpg123 xvfb wx3.2-i18n python3-psutil \
  bluetooth libbluetooth-dev python3-websocket python3-bluez python3-dbus python3-gdal python3-pip \
  python3-pyudev python3-netifaces \
  libwxgtk3.2-1=3.2.2+dfsg-2 libglu1-mesa libarchive13

wget --user-agent="$AGENT" -O avnav.deb https://www.free-x.de/debian/pool/main/a/avnav/avnav_20240616_all.deb
dpkg -i avnav.deb
rm -f avnav.deb

wget --user-agent="$AGENT" -O avnav-history-plugin.deb https://www.free-x.de/debian/pool/main/a/avnav-history-plugin/avnav-history-plugin_20210525_all.deb
wget --user-agent="$AGENT" -O avnav-mapproxy-plugin.deb https://www.free-x.de/debian/pool/main/a/avnav-mapproxy-plugin/avnav-mapproxy-plugin_20230214_all.deb
#wget --user-agent="$AGENT" -O avnav-sailinstrument-plugin.deb https://github.com/kdschmidt1/Sail_Instrument/releases/download/20240503/avnav-sailinstrument-plugin_20240503_all.deb
dpkg -i avnav-history-plugin.deb avnav-mapproxy-plugin.deb #avnav-sailinstrument-plugin.deb
rm -f avnav-history-plugin.deb avnav-mapproxy-plugin.deb #avnav-sailinstrument-plugin.deb

wget --user-agent="$AGENT" -O avnav-ocharts-plugin.deb https://www.free-x.de/debian/pool/main/a/avnav-ocharts-plugin/avnav-ocharts-plugin_20231216-raspbian-bookworm_arm64.deb
wget --user-agent="$AGENT" -O avnav-ocharts.deb https://www.free-x.de/debian/pool/main/a/avnav-ocharts/avnav-ocharts_1.0.44.0-1bookworm1_arm64.deb
dpkg -i avnav-ocharts-plugin.deb avnav-ocharts.deb
rm -f avnav-ocharts-plugin.deb avnav-ocharts.deb

wget --user-agent="$AGENT" -O avnav-sailinstrument-plugin.deb https://www.free-x.de/debian/pool/main/a/avnav-sailinstrument-plugin/avnav-sailinstrument-plugin_20240503_all.deb
dpkg -i avnav-sailinstrument-plugin.deb
rm -f avnav-sailinstrument-plugin.deb

install -o 0 -g 0 -d /usr/lib/systemd/system/avnav.service.d
install -o 0 -g 0 -m 0644 "$FILE_FOLDER"/lys-avnav.conf /usr/lib/systemd/system/avnav.service.d/
install -o 0 -g 0 -d /usr/lib/avnav/lysmarine
install -o 0 -g 0 -m 0644 "$FILE_FOLDER"/avnav_server_lysmarine.xml "/usr/lib/avnav/lysmarine/"

install -m 755 "$FILE_FOLDER"/avnav-restart "/usr/local/sbin/avnav-restart"

npm cache clean --force

echo "" >>/etc/sudoers
echo 'user ALL=(ALL) NOPASSWD: /usr/local/sbin/avnav-restart' >>/etc/sudoers

usermod -a -G lirc avnav

systemctl enable avnav
