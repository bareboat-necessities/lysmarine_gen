#!/bin/bash -e

# see: https://github.com/victronenergy/venus-docker

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc
  do apt-get remove $pkg
done

# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/raspbian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/raspbian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

apt-get install -q -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

pushd /root
  git clone --recurse-submodules https://github.com/victronenergy/venus-docker
  pushd venus-docker
    ./build.sh
  popd
popd

