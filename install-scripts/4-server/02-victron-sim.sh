#!/bin/bash -e

# install docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc
  do apt-get -q -y remove $pkg
done

apt-get install -q -y ebtables docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

export DOCKER_HOST=tcp://127.0.0.1:2375
docker load --input "$FILE_FOLDER/mqtt.tar"
docker images
