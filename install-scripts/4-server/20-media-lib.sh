#!/bin/bash -e

# TODO:
exit 0

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

#apt-get install -y jellyfin

xargs -n 1 -P 4 wget -q << EOF
https://repo.jellyfin.org/files/server/debian/latest-stable/arm64/jellyfin-server_10.9.6%2Bdeb12_arm64.deb
https://repo.jellyfin.org/files/server/debian/latest-stable/arm64/jellyfin_10.9.6%2Bdeb12_all.deb
https://repo.jellyfin.org/files/server/debian/latest-stable/arm64/jellyfin-web_10.9.6%2Bdeb11_all.deb
https://repo.jellyfin.org/files/ffmpeg/debian/latest-6.x/arm64/jellyfin-ffmpeg6_6.0.1-7-bookworm_arm64.deb
EOF

dpkg -i jellyfin*.deb
rm -rf jellyfin*.deb

adduser jellyfin audio

systemctl disable jellyfin
