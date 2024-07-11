#!/bin/bash -e
apt-get install -y -q parted # plymouth plymouth-label libblockdev-mdraid2

# TODO:
exit 0

## This override the default tty1 behaviour to make it more discrete during the boot process
install -v -d "/etc/systemd/system/getty@tty1.service.d"
install -v -m0644 "$FILE_FOLDER"/skip-prompt.conf "/etc/systemd/system/getty@tty1.service.d/"

# RaspOS
if [ -f /boot/config.txt ]; then
  if [ "$LMARCH" == 'armhf' ]; then
    echo "arm_64bit=1" >> "$(realpath /boot/config.txt)"
  fi
	cat "$FILE_FOLDER"/appendToConfig.txt >> "$(realpath /boot/config.txt)"
	#sed -i 's/-kms-v3d$/-fkms-v3d,cma-128/' /boot/config.txt # breaks on bookworm
fi

## RaspOS
# systemd.run=/boot/firstrun.sh systemd.run_success_action=reboot systemd.unit=kernel-command-line.target
# console=serial0,115200 console=tty1 root=PARTUUID=7788c428-02 rootfstype=ext4 fsck.repair=yes rootwait quiet init=/usr/lib/raspberrypi-sys-mods/firstboot cfg80211.ieee80211_regdom=US systemd.run=/boot/firstrun.sh systemd.run_success_action=reboot systemd.unit=kernel-command-line.target
if [ -f /boot/cmdline.txt ]; then
  sed -i '$s/$/\ console=tty1\ loglevel=1\ splash\ logo.nologo\ cfg80211.ieee80211_regdom=US\ vt.global_cursor_default=1\ plymouth.ignore-serial-consoles\ console=tty3/' "$(realpath /boot/cmdline.txt)"
  #sed -i '$s/$/\ systemd.run=\/boot\/firstrun.sh\ systemd.run_success_action=reboot\ systemd.unit=kernel-command-line.target/' "$(realpath /boot/cmdline.txt)"
  sed -i 's#console=serial0,115200 ##' "$(realpath /boot/cmdline.txt)"
  sed -i 's#console=/dev/serial0,115200 ##' "$(realpath /boot/cmdline.txt)"
  sed -i 's#console=serial0,9600 ##' "$(realpath /boot/cmdline.txt)"
  sed -i 's#console=/dev/serial0,9600 ##' "$(realpath /boot/cmdline.txt)"

	setterm -cursor on >> /etc/issue
	echo 'i2c_dev' | tee -a /etc/modules
fi

## Armbian
if [ -f /boot/armbianEnv.txt ]; then
	echo "console=serial" >> /boot/armbianEnv.txt
fi

# Debian
if [ -f /etc/default/grub ] ; then
  install -m0644 -v "$FILE_FOLDER"/grub "/etc/default/grub"
  install -m0644 -v "$FILE_FOLDER"/background.png "/boot/grub/background.png"
  echo FRAMEBUFFER=y >> /etc/initramfs-tools/conf.d/splash
  update-initramfs -u
  update-grub
fi

# Theming of the boot process
install -v "$FILE_FOLDER"/ascii_logo.txt "/etc/motd"
cp -r "$FILE_FOLDER"/dreams "/usr/share/plymouth/themes/"
plymouth-set-default-theme dreams

# Armbian
if [ -f /etc/issue ]; then
	rm /etc/issue /etc/issue.net
fi

# Raspbian enable this to intercept keystroke during the boot process, (for ondemand cup freq management.) We don't want to set it that way.
systemctl disable triggerhappy.service
systemctl disable triggerhappy.socket

install -v -m0644 "$FILE_FOLDER"/plymouth-start.service "/etc/systemd/system/"

install -v -d "/etc/systemd/system/console-setup.service.d"
bash -c 'cat << EOF > /etc/systemd/system/console-setup.service.d/override.conf
[Unit]
After=systemd-tmpfiles-setup.service
EOF'

#
#install -v -d "/etc/systemd/system/keyboard-setup.service.d"
#bash -c 'cat << EOF > /etc/systemd/system/keyboard-setup.service.d/override.conf
#[Unit]
#After=systemd-tmpfiles-setup.service
#EOF'

# Swap
sed -i 's/CONF_SWAPSIZE=100$/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile


#systemctl disable systemd-firstboot.service

