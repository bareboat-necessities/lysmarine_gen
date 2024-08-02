#!/bin/bash -e

# install docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc
  do apt-get -q -y remove $pkg
done

apt-get install -q -y ebtables docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

install -d /root/victron
mv "$FILE_FOLDER/mqtt.tar" "/root/victron/"

o_dir=$(pwd)
cd /root/victron
git clone --depth=1 --recurse-submodules https://github.com/victronenergy/venus-docker
cd "$o_dir"

cat >/root/victron/readme.txt <<'EOF'
This is Victron simulator docker image
To load:

docker load --input ./mqtt.tar
docker images

See: https://github.com/victronenergy/venus-docker/

EOF
