#!/bin/bash -e

install -o 1000 -g 1000 -v "$FILE_FOLDER"/boatinstrument.json "/root/boatinstrument.json"
install -o 1000 -g 1000 -v "$FILE_FOLDER"/boatinstrument.json "/root/boatinstrument.json-bbn"
install -o 1000 -g 1000 -v "$FILE_FOLDER"/boatinstrument-detailed.json "/root/boatinstrument-detailed.json-bbn"

apt-get install -y libinput10 libvulkan1 libgstreamer-plugins-base1.0-0 libseat1

BK_DIR="$(pwd)"

cd /root

wget -O boatinstrument.tgz https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/boatinstrument-0.3.0.3-flutterpi_arm32.tgz
gzip -cd < boatinstrument.tgz | tar xvf -
rm -f boatinstrument.tgz

cd "$BK_DIR"

install -d /etc/systemd/system
install -m 644 "$FILE_FOLDER"/boatinstrument-flutter-pi.service "/etc/systemd/system/boatinstrument-flutter-pi.service"

systemctl disable boatinstrument-flutter-pi

usermod -a -G render user

