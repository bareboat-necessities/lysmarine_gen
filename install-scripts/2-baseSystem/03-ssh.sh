#!/bin/bash -e

# TODO:
exit 0

apt-get install -y -q openssh-server

## If nothing specified (line commented), then forbid login as root
sed -i 's/^\#PermitRootLogin\ */PermitRootLogin\ no\ \#/g' /etc/ssh/sshd_config

systemctl enable ssh
