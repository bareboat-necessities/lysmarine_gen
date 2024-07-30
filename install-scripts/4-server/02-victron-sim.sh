#!/bin/bash -e

# see: https://github.com/victronenergy/venus-docker
apt-get install -y -q docker.io

pushd /root
  git clone --recurse-submodules https://github.com/victronenergy/venus-docker
  pushd venus-docker
    ./build.sh
  popd
popd

