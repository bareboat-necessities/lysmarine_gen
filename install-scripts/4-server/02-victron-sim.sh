#!/bin/bash -e

# install docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc
  do apt-get -q -y remove $pkg
done

apt-get install -q -y ebtables docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

docker run -v /var/run/docker.sock:/var/run/docker.sock -ti docker

# see: https://github.com/victronenergy/venus-docker
pushd /root
  git clone --recurse-submodules https://github.com/victronenergy/venus-docker
  pushd venus-docker
    ./build.sh
  popd
popd

