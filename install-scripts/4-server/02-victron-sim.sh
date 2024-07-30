#!/bin/bash -e

# install docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc
  do apt-get remove $pkg
done

apt-get install -q -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# see: https://github.com/victronenergy/venus-docker
pushd /root
  git clone --recurse-submodules https://github.com/victronenergy/venus-docker
  pushd venus-docker
    ./build.sh || true
  popd
popd

