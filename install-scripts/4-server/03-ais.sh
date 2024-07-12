#!/bin/bash -e

## https://pysselilivet.blogspot.com/2018/06/ais-reciever-for-raspberry.html

# moved into 00-radio-sdr.sh
#apt-get install -y -q rtl-ais kalibrate-rtl

## Adding service file
install -v -m 0644 "$FILE_FOLDER"/rtl-ais.service "/etc/systemd/system/"
systemctl disable rtl-ais.service



# AIS-Catcher https://github.com/jvde-github/AIS-catcher
apt-get install -y librtlsdr0 libairspy0 libairspyhf1 \
  libhackrf0 libsoapysdr0.8 libzmq3-dev libcurl4-openssl-dev zlib1g

#wget -q -O - https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/AIS-catcher-20231216-bookworm-arm64.zip > AIS-catcher.zip
#unzip AIS-catcher.zip && rm AIS-catcher.zip
#mv AIS-catcher /usr/local/bin/ && chmod +x /usr/local/bin/AIS-catcher

AGENT="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"
xargs -n 1 -P 2 wget --user-agent="$AGENT" -q << EOF
https://www.free-x.de/deb4op/pool/main/a/ais-catcher-webassets/ais-catcher-webassets_20240208_all.deb
https://www.free-x.de/deb4op/pool/main/a/ais-catcher/ais-catcher_0.5.9-deb12u1_arm64.deb
EOF
dpkg -i ais-catcher_*.deb ais-catcher-webassets_*.deb
rm -rf ais-catcher*.deb
