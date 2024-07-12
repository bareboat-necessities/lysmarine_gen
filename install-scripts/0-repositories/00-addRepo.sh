#!/bin/bash -e

apt-get update  -y -q
apt-get install -y -q wget gnupg ca-certificates

## Add repository sources
install -m 0644 -v "$FILE_FOLDER"/nodesource.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/mosquitto.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/grafana.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/raspotify.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/jellyfin.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/debian-backports.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/avnav.list "/etc/apt/sources.list.d/"

## Prefer opencpn PPA to free-x (for mainly for the opencpn package)
install -m 0644 -v "$FILE_FOLDER"/50-lysmarine.pref "/etc/apt/preferences.d/"

## Get the signature keys
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 684A14CF2582E0C5            # Influx

wget -q -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -    # NodeJs
wget -q -O - https://repos.influxdata.com/influxdb.key | apt-key add -
wget -q -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | apt-key add -
curl -sSL https://dtcooper.github.io/raspotify/key.asc | apt-key add -
curl -1sLf https://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add -  # Mosquitto

wget -q -O - https://www.free-x.de/debian/oss.boating.gpg.key     | apt-key add -    # XyGrib, AvNav
curl -1sLf https://open-mind.space/repo/open-mind.space.gpg.key | apt-key add -      # AvNav
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor > /usr/share/keyrings/grafana.gpg

wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list
rm influxdata-archive_compat.key

## Update && Upgrade
apt-get update  -y -q
apt-mark hold linux-base
apt-get upgrade -y -q
apt-get autoremove -y --purge

#systemctl preset-all
