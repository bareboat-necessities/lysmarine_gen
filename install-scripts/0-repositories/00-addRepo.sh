#!/bin/bash -e


apt-get update  -y -q
apt-get install -y -q wget gnupg ca-certificates

# TODO
exit 0


## Add repository sources
install -m 0644 -v "$FILE_FOLDER"/nodesource.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/mosquitto.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/grafana.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/mopidy.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/bbn-gpsd.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/bbn-autoadb.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/bbn-rce.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/raspotify.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/jellyfin.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/debian-backports.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/opencpn.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/xygrib.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/lysmarine.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/bbn-kplex.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/bbn-navtex.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/bbn-noaa-apt.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/avnav.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/openplotter.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/chirp.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/stellarium.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/piaware-bookworm.list "/etc/apt/sources.list.d/"
#install -m 0644 -v "$FILE_FOLDER"/box86.list "/etc/apt/sources.list.d/"

#wget -O /etc/apt/sources.list.d/piaware.list https://abcd567a.github.io/rpi/abcd567a.list
#wget -O /etc/apt/sources.list.d/box86.list https://ryanfortner.github.io/box86-debs/box86.list


## Prefer opencpn PPA to free-x (for mainly for the opencpn package)
install -m 0644 -v "$FILE_FOLDER"/50-lysmarine.pref "/etc/apt/preferences.d/"

## Get the signature keys
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 684A14CF2582E0C5           # Influx
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC           # debian backports (stretch)
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138           # debian backports (buster)
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 24A4598E769C8C51           # bbn PPAs on launchpad
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67E4A52AC865EB40           # Opencpn
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF0E1940624A220           # Opencpn
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 868273EDCE9979E7           # lysmarine (provide: createap, rtl-ais, fbpanel)
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6EA1BC913BC5163F           # Chirp
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1932F485C68D72A5           # Stellarium

wget -q -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -    # NodeJs
#wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
wget -q -O - https://repos.influxdata.com/influxdb.key | apt-key add -
wget -q -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | apt-key add -
curl -sSL https://dtcooper.github.io/raspotify/key.asc | apt-key add -
curl -1sLf https://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add - # Mosquitto
#curl -1sLf https://dl.cloudsmith.io/public/bbn-projects/bbn-autoadb/gpg.A63E85DF4575A096.key | apt-key add -
#curl -1sLf https://dl.cloudsmith.io/public/bbn-projects/bbn-gpsd/gpg.B3336FAFD344E1C5.key | apt-key add -

wget -q -O - https://www.free-x.de/debian/oss.boating.gpg.key     | apt-key add -    # XyGrib, AvNav
#wget -q -O - https://raw.githubusercontent.com/openplotter/openplotter-settings/master/openplotterSettings/data/sources/openplotter.gpg.key | apt-key add -
#curl -1sLf https://dl.cloudsmith.io/public/bbn-projects/bbn-rce/gpg.540A03461CECBA19.key | apt-key add -
#curl -1sLf https://dl.cloudsmith.io/public/bbn-projects/bbn-kplex/gpg.B487196268D0D9B6.key | apt-key add -
#curl -1sLf https://dl.cloudsmith.io/public/bbn-projects/bbn-noaa-apt/gpg.DB5121F72251E833.key | apt-key add -
#curl -1sLf https://dl.cloudsmith.io/public/bbn-projects/bbn-navtex/gpg.DCC56162C6CE6F68.key | apt-key add -
#curl -1sLf https://raw.githubusercontent.com/bareboat-necessities/lysmarine_gen/master/public-keys/cloudsmith-bbn-noaa-apt/gpg.DB5121F72251E833.key | apt-key add -
#curl -1sLf https://open-mind.space/repo/open-mind.space.gpg.key | apt-key add -     # AvNav
#curl -1sLf https://raw.githubusercontent.com/bareboat-necessities/lysmarine_gen/master/public-keys/flightaware/gpg.flightaware.key | apt-key add -

#wget -O /etc/apt/trusted.gpg.d/abcd567a-key.gpg https://abcd567a.github.io/rpi/KEY2.gpg # PiAware
#wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | gpg --dearmor | tee /usr/share/keyrings/box86-debs-archive-keyring.gpg # Box86
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor > /usr/share/keyrings/grafana.gpg

wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list
rm influxdata-archive_compat.key

#wget https://www.flightaware.com/adsb/piaware/files/packages/pool/piaware/f/flightaware-apt-repository/flightaware-apt-repository_1.2_all.deb
#dpkg -i flightaware-apt-repository_1.2_all.deb
#rm -f flightaware-apt-repository_1.2_all.deb

## Update && Upgrade
apt-get update  -y -q
#apt-mark hold linux-image-rpi-2712 linux-image-rpi-v8 linux-headers-rpi-2712 linux-headers-rpi-v8 linux-libc-dev
apt-mark hold linux-base
apt-get upgrade -y -q
apt-get autoremove -y --purge

#systemctl preset-all
