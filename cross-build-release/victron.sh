#!/bin/bash -xe

git clone --recurse-submodules --depth=1 https://github.com/victronenergy/venus-docker
pushd venus-docker
  export DOCKER_DEFAULT_PLATFORM=linux/arm/v7
  docker build . -t mqtt
  docker save --output mqtt.tar mqtt
  ls -l mqtt.tar
popd
pwd
ls -l "$(pwd)"
mv venus-docker/mqtt.tar "$(pwd)"/install-scripts/4-server/files/
rm -rf ./venus-docker
