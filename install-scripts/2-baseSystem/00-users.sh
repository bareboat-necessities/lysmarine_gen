#!/bin/bash -e

### Set root password.
echo 'root:changeme' | chpasswd

## Remove default user (if any).
oldUser=$(grep 1000:1000 /etc/passwd | cut -f1 -d:)
if [[ -n $oldUser ]]; then
	echo "Removing user $oldUser"
	userdel -r -f "$oldUser"
else
	echo "No default user found !"
fi

groupadd -r spi

## Add default user.
adduser --uid 1000 --home /home/user --quiet --disabled-password -gecos "bbn" user
echo 'user:changeme' | chpasswd
echo "user ALL=(ALL:ALL) ALL" >> /etc/sudoers
usermod -a -G netdev user
usermod -a -G adm user
usermod -a -G tty user
usermod -a -G i2c user
usermod -a -G spi user
usermod -a -G gpio user
usermod -a -G sudo user
usermod -a -G video user
usermod -a -G input user     # for evdev-rce
usermod -a -G audio user
usermod -a -G dialout user
usermod -a -G lp user
usermod -a -G cdrom user
usermod -a -G plugdev user
usermod -a -G fax user
usermod -a -G voice user
usermod -a -G users user

# LIRC
groupadd -r lirc
useradd -r -g lirc -d /var/lib/lirc -s /usr/bin/nologin -c "LIRC daemon user" lirc
usermod -a -G input lirc

echo 'PATH="/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:$PATH"' >> /home/user/.profile # Give user capability to halt and reboot.

