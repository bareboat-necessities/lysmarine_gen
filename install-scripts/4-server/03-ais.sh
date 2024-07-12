#!/bin/bash -e

## https://pysselilivet.blogspot.com/2018/06/ais-reciever-for-raspberry.html

# moved into 00-radio-sdr.sh
#apt-get install -y -q rtl-ais kalibrate-rtl

## Adding service file
install -v -m 0644 "$FILE_FOLDER"/rtl-ais.service "/etc/systemd/system/"
systemctl disable rtl-ais.service

#TODO:
#exit 0

# AIS-Catcher https://github.com/jvde-github/AIS-catcher
apt-get install -y librtlsdr0 libairspy0 libairspyhf1 \
  libhackrf0 libsoapysdr0.8 libzmq3-dev libcurl4-openssl-dev zlib1g

AGENT="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"
xargs -n 1 -P 2 wget --user-agent="$AGENT" -q << EOF
https://www.free-x.de/deb4op/pool/main/a/ais-catcher-webassets/ais-catcher-webassets_20240208_all.deb
https://www.free-x.de/deb4op/pool/main/a/ais-catcher/ais-catcher_0.5.9-deb12u1_armhf.deb
EOF
dpkg -i ais-catcher_*.deb ais-catcher-webassets_*.deb
rm -rf ais-catcher*.deb
