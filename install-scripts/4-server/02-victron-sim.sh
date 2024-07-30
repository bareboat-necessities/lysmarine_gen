#!/bin/bash -e

# install docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc
  do apt-get -q -y remove $pkg
done

apt-get install -q -y ebtables docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# see: https://github.com/victronenergy/venus-docker
pushd /root
  git clone --recurse-submodules https://github.com/victronenergy/venus-docker
  pushd venus-docker
    git submodule update --init --recursive
    git submodule foreach 'git pull --ff origin master --recurse-submodules || true'
    docker buildx create --buildkitd-flags '--allow-insecure-entitlement security.insecure' --name insecure-builder
    docker buildx use insecure-builder
    export DOCKER_HOST=tcp://127.0.0.1:2375
    docker buildx build --allow security.insecure . -t mqtt --no-cache
  popd
popd

