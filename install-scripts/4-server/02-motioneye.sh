#!/bin/bash -e

rm -rf /usr/lib/python3.11/EXTERNALLY-MANAGED

# TODO:
exit 0

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

apt-get clean

# See: https://github.com/motioneye-project/motioneye/tree/dev

apt-get -y -q  --no-install-recommends --no-install-suggests install ca-certificates curl python3 \
  python3-dev python3-pip libcurl4-openssl-dev gcc libssl-dev

pip3 install 'https://github.com/motioneye-project/motioneye/archive/dev.tar.gz'

motioneye_init

mkdir -p /etc/motioneye
#cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf

mkdir -p /var/lib/motioneye

install -m 755 -d -o motion -g motion "/var/log/motion"
install -m 755 -d -o motion -g motion "/var/lib/motion"

# resolve conflict with pypilot_web
sed -i "s/8080/8480/g" /etc/motion/motion.conf

#cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
#systemctl daemon-reload
systemctl enable motioneye
#systemctl start motioneye

# TODO: temp fix
pip3 install requests==2.29.0

apt-get clean

# http://localhost:8765/
# default user admin
# password is empty
