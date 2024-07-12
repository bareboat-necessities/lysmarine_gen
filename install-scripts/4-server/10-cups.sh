#!/bin/bash -e

# TODO:
exit 0

apt-get -y -q --no-install-recommends --no-install-suggests install cups

usermod -a -G lpadmin user

