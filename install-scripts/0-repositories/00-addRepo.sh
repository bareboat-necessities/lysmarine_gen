#!/bin/bash -e

apt-get install -y -q wget gnupg ca-certificates

install -m 0644 -v "$FILE_FOLDER"/free-x.list "/etc/apt/sources.list.d/"
install -m 0644 -v "$FILE_FOLDER"/debian-backports.list "/etc/apt/sources.list.d/"

wget -q -O - https://www.free-x.de/debian/oss.boating.gpg.key     | apt-key add -

# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/raspbian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/raspbian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update  -y -q
apt-get upgrade  -y -q
