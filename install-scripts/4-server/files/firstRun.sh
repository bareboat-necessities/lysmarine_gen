#!/bin/sh

rm -f /etc/localtime
echo "Etc/UTC" >/etc/timezone

dpkg-reconfigure -f noninteractive tzdata
cat >/etc/default/keyboard <<'KBEOF'
XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS=""

KBEOF
dpkg-reconfigure -f noninteractive keyboard-configuration

/usr/local/m5stack/resize_mmc.sh

sync
reboot -f
