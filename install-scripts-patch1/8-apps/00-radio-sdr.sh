#!/bin/bash -e

apt-get clean

# AIS-Catcher https://github.com/jvde-github/AIS-catcher
apt-get install -y librtlsdr0 libairspy0 libairspyhf1 \
  libhackrf0 libsoapysdr0.7 libzmq3-dev libcurl4-openssl-dev zlib1g

wget -q -O - https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/AIS-catcher-20221109-arm64.zip > AIS-catcher.zip
unzip AIS-catcher.zip && rm AIS-catcher.zip
mv AIS-catcher /usr/local/bin/ && chmod +x /usr/local/bin/AIS-catcher
