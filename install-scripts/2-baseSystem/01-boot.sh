#!/bin/bash -e
apt-get install -y -q parted gdisk # plymouth plymouth-label libblockdev-mdraid2

if [ -f /usr/local/m5stack/init.sh ] ; then
  install -m0644 -v "$FILE_FOLDER"/bbn_logo.jpg "/usr/local/m5stack/bbn_logo.jpg"
  sed -i "s#m5stack/logo.jpg#m5stack/bbn_logo.jpg#g" /usr/local/m5stack/init.sh
fi

# TODO:
exit 0

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

