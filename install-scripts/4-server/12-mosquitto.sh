#!/bin/bash -e

apt-get -y -q install mosquitto mosquitto-clients

install -d -o mosquitto -g mosquitto "/var/log/mosquitto"

# for mDNS
install -v -m 0644 "$FILE_FOLDER"/mosquitto_service "/etc/avahi/services/mosquitto.service"

systemctl disable mosquitto
