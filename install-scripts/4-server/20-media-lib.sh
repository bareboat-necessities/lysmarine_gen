#!/bin/bash -e

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

#apt-get install -y jellyfin

apt-get clean
rm -rf /var/cache/apt/archives/*
rm -rf ~/.cache/pip

xargs -n 1 -P 4 wget -q << EOF
https://repo.jellyfin.org/files/server/debian/latest-stable/arm64/jellyfin-server_10.10.7%2Bdeb12_arm64.deb
https://repo.jellyfin.org/files/server/debian/latest-stable/arm64/jellyfin_10.10.7%2Bdeb12_all.deb
https://repo.jellyfin.org/files/server/debian/latest-stable/arm64/jellyfin-web_10.10.7%2Bdeb12_all.deb
https://repo.jellyfin.org/files/ffmpeg/debian/latest-7.x/arm64/jellyfin-ffmpeg7_7.0.2-9-bookworm_arm64.deb
EOF

dpkg -i jellyfin*.deb
rm -rf jellyfin*.deb

adduser jellyfin audio

systemctl disable jellyfin
