#!/bin/bash -e

apt-get remove -y unattended-upgrades # exim4-base

apt-get autoremove -y --purge

apt-get -y autoremove
apt-get clean
npm cache clean --force || true
rm -rf /.local/share/pnpm

# remove python pip cache
rm -rf /.cache/pip

# remove all cache
rm -rf /.cache
rm -rf /.config
rm -rf /.npm
rm -rf /.wget*
rm -rf $(find /var/log/ -type f)
rm -f /opt/vc/src/hello_pi/hello_video/test.h264

rm -f /usr/share/applications/org.buddiesofbudgie.BudgieScreenshot.desktop

echo '/usr/lib /usr/share /usr/include /usr/bin /srv' | xargs -n 1 -P 4 hardlink -v -t

# clean up more
rm -rf /usr/share/doc/noaa-apt/docs/examples/argentina.wav*
rm -rf /usr/share/doc/nodejs/api/
rm -rf /usr/share/doc/nodejs/changelogs/
rm -rf /usr/share/doc/tcllib/html/
rm -rf /usr/share/doc/openjdk*/test*/*
rm -rf /usr/share/doc/python3*/HISTORY.*
rm -rf /usr/share/doc/python3*/NEWS.*
rm -rf /usr/share/backgrounds/budgie/*
rm -rf /var/lib/apt/lists/*
rm -rf /usr/share/applications/*ts_calibrate*.desktop
rm -rf /usr/share/applications/*ts_test*.desktop
rm -f /2
find /usr/share/doc -name changelog\*.gz -exec rm -f {} \;
find /usr/share/doc -name NEWS\*.gz -exec rm -f {} \;

if [ "$BBN_KIND" == "LITE" ] ; then
  echo 1 > /etc/bbn-lite
fi

date --rfc-3339=seconds > /etc/bbn-build
fake-hwclock save

chown root:root /
chmod 755 /

# Fill free space with zeros
cat /dev/zero > /zer0s || true
rm -f /zer0s
