#!/bin/bash -e

apt-get clean

apt-get -y -q install geographiclib-tools libqt5charts5 libqt5multimediawidgets5 libqt5script5 # stellarium stellarium-data

wget http://ppa.launchpad.net/stellarium/stellarium-releases/ubuntu/pool/main/s/stellarium/stellarium_23.4.0-upstream1.1~ubuntu20.04.1_arm64.deb
wget http://ppa.launchpad.net/stellarium/stellarium-releases/ubuntu/pool/main/s/stellarium/stellarium-data_23.4.0-upstream1.1~ubuntu20.04.1_all.deb

sudo dpkg-deb -xv stellarium_*.deb /
sudo dpkg-deb -xv stellarium-data*.deb /
sudo chown root:root /
sudo chmod 755 /
rm -f stellarium*.deb

install -d -o 1000 -g 1000 -m 0755 "/home/user/.stellarium"
install -v -o 1000 -g 1000 -m 0644 "$FILE_FOLDER"/stellarium-config.ini "/home/user/.stellarium/config.ini"

install -v -m 0644 "$FILE_FOLDER"/org.stellarium.Stellarium.desktop /usr/share/applications/
install -v -m 0755 "$FILE_FOLDER"/stellarium-augmented.sh /usr/local/bin/stellarium-augmented

geographiclib-get-magnetic all

apt-get clean

apt-mark hold stellarium stellarium-data
