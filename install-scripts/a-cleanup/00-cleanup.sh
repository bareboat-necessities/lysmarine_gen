#!/bin/bash -e
rm -rf  /tmp/empty-cache46
rm -rvf /home/user/Public /home/user/Templates 

apt-get clean

apt-get remove -y greybird-gtk-theme murrine-themes rpd-icons

apt-get -y autoremove
apt-get clean
npm cache clean --force
pnpm cache clean --force

# remove python pip cache
rm -rf ~/.cache/pip

# remove all cache
rm -rf ~/.cache
rm -rf ~/.config
rm -rf ~/.npm
rm -rf ~/.wget*
rm -rf $(find /var/log/ -type f)
rm -f /opt/vc/src/hello_pi/hello_video/test.h264

apt-get -q -y install --download-only avnav-update-plugin

for f in /etc/apt/sources.list.d/bbn-*.list
do
  mv "$f" "$f"-orig
done

# These are launchpad. They are ok to have.
mv /etc/apt/sources.list.d/bbn-rce.list-orig /etc/apt/sources.list.d/bbn-rce.list
mv /etc/apt/sources.list.d/bbn-kplex.list-orig /etc/apt/sources.list.d/bbn-kplex.list

install -v -m 0644 $FILE_FOLDER/rsyslog "/etc/logrotate.d/rsyslog"

# Fill free space with zeros
cat /dev/zero > /zer0s || true
rm -f /zer0s

date --rfc-3339=seconds > /etc/bbn-build
fake-hwclock save
