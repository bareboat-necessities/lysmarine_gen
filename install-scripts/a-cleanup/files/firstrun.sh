#!/bin/bash

# rpi-imager generated with defaults for user, host etc
# goes into /boot/

set +e

CURRENT_HOSTNAME=$(cat /etc/hostname | tr -d " \t\n\r")
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_hostname coremp135
else
   echo coremp135 >/etc/hostname
   sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\tcoremp135/g" /etc/hosts || true
fi
FIRSTUSER=$(getent passwd 1000 | cut -d: -f1)
FIRSTUSERHOME=$(getent passwd 1000 | cut -d: -f6)
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom enable_ssh
else
   systemctl enable ssh
fi
if [ -f /usr/lib/userconf-pi/userconf ]; then
   /usr/lib/userconf-pi/userconf 'user' '$5$lLZpPB6mfz$KT6SHSKYvLWGELY19or7KlgV8K8ucgVZH2fTDI8eUU2'
else
   echo "$FIRSTUSER:"'$5$lLZpPB6mfz$KT6SHSKYvLWGELY19or7KlgV8K8ucgVZH2fTDI8eUU2' | chpasswd -e
   if [ "$FIRSTUSER" != "user" ]; then
      usermod -l "user" "$FIRSTUSER"
      usermod -m -d "/home/user" "user"
      groupmod -n "user" "$FIRSTUSER"
      if [ -f /etc/lightdm/lightdm.conf ]; then
        if grep -q "^autologin-user=" /etc/lightdm/lightdm.conf ; then
           sed /etc/lightdm/lightdm.conf -i -e "s/^autologin-user=.*/autologin-user=user/"
        fi
      fi
      if [ -f /etc/systemd/system/getty@tty1.service.d/autologin.conf ]; then
         sed /etc/systemd/system/getty@tty1.service.d/autologin.conf -i -e "s/$FIRSTUSER/user/"
      fi
      if [ -f /etc/sudoers.d/010_pi-nopasswd ]; then
         sed -i "s/^$FIRSTUSER /user /" /etc/sudoers.d/010_pi-nopasswd
      fi
   fi
fi
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
  /usr/lib/raspberrypi-sys-mods/imager_custom set_wlan 'coremp135-hotspot' '9edadd0c8b779a33b4f336efa49535aa9a5a1c7809a457abb71fd68a1925d91f' 'US'
else
  cat >/etc/wpa_supplicant/wpa_supplicant.conf <<'WPAEOF'
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
ap_scan=1

update_config=1
network={
	ssid="coremp135-hotspot"
	psk=9edadd0c8b779a33b4f336efa49535aa9a5a1c7809a457abb71fd68a1925d91f
}

WPAEOF
   chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf
   rfkill unblock wifi
   for filename in /var/lib/systemd/rfkill/*:wlan ; do
       echo 0 > "$filename"
   done
fi

if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_keymap 'us'
   /usr/lib/raspberrypi-sys-mods/imager_custom set_timezone 'Etc/UTC'
else
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
fi
rm -f /boot/firstrun.sh
sed -i 's| systemd.run.*||g' "$(realpath /boot/cmdline.txt)"
exit 0

