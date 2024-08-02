#!/usr/bin/env bash

#
# Build for Debian in a docker container
#

# bailout on errors and echo commands.
set -xe

LYSMARINE_VER=$(date +%Y-%m-%d-r%H%M)
DOCKER_SOCK="unix:///var/run/docker.sock"

echo "DOCKER_OPTS=\"-H tcp://127.0.0.1:2375 -H $DOCKER_SOCK -s overlay2\"" | sudo tee /etc/default/docker >/dev/null
sudo service docker restart
sleep 3

if [ "$EMU" = "on" ]; then
  if [ "$CONTAINER_DISTRO" = "raspbian" ]; then
    docker run --rm --privileged --cap-add=ALL --security-opt="seccomp=unconfined" multiarch/qemu-user-static:register --reset --credential yes --persistent yes
  else
    docker run --rm --privileged --cap-add=ALL --security-opt="seccomp=unconfined" multiarch/qemu-user-static --reset --credential yes --persistent yes
  fi
fi

WORK_DIR=$(pwd):/ci-source

git clone --recurse-submodules https://github.com/victronenergy/venus-docker
pushd venus-docker
#  git submodule update --init --recursive
#  git submodule foreach 'git pull --ff origin master --recurse-submodules || true'
  docker buildx create --buildkitd-flags '--allow-insecure-entitlement security.insecure' --name insecure-builder
  docker buildx use insecure-builder
  #export DOCKER_HOST=tcp://127.0.0.1:2375
  ls -l /var/run/docker.sock
  docker buildx build --allow security.insecure . -t mqtt --no-cache
popd

docker run --privileged --cap-add=ALL --security-opt="seccomp=unconfined" -d -ti -e "container=docker" -v /var/run/docker.sock:/var/run/docker.sock -v "$WORK_DIR":rw -v /dev:/dev "$DOCKER_IMAGE" /bin/bash
DOCKER_CONTAINER_ID=$(docker ps --last 4 | grep "$CONTAINER_DISTRO" | awk '{print $1}' | head -1)

docker exec --privileged -ti "$DOCKER_CONTAINER_ID" apt-get update
docker exec --privileged -ti "$DOCKER_CONTAINER_ID" apt-get -y install dpkg-dev debhelper devscripts equivs pkg-config apt-utils fakeroot \
  proot git-core live-build kpartx p7zip p7zip-full parted fdisk gdisk e2fsprogs qemu-user zerofree

docker exec --privileged -ti "$DOCKER_CONTAINER_ID" /bin/bash -xec \
  "cd ci-source/cross-build-release; chmod -v u+w *.sh; /bin/bash -xe ./debian.sh $PKG_ARCH $LYSMARINE_VER $BBN_KIND $DOCKER_CONTAINER_ID"

pwd
ls
ls cross-build-release/release/*/*.img

echo "Stopping"
docker ps -a
docker stop "$DOCKER_CONTAINER_ID"
docker rm -v "$DOCKER_CONTAINER_ID"
