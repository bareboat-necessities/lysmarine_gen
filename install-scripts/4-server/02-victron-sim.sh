#!/bin/bash -e

# install docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc
  do apt-get -q -y remove $pkg
done

update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

apt-get install -q -y ebtables docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# see: https://github.com/victronenergy/venus-docker
pushd /root
  git clone --recurse-submodules https://github.com/victronenergy/venus-docker
  pushd venus-docker
    ./build.sh || true
  popd
popd

