#!/bin/bash -e

# TODO:
exit 0

echo "samba-common samba-common/workgroup string WORKGROUP" | debconf-set-selections
echo "samba-common samba-common/dhcp boolean true" | debconf-set-selections
echo "samba-common samba-common/do_debconf boolean true" | debconf-set-selections

apt-get -y -q install samba samba-common samba-client smbnetfs winbind

# systemctl enable smbd

install -m 755 -d -o root -g adm "/var/log/samba"
#install -m 755 -d -o root -g adm "/var/log/samba/cores"
