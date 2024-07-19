#!/bin/bash -e

apt-get -y -q install canboat can-utils dfu-util

yes | cpan install Config::General # for canboat n2kd_monitor

systemctl disable canboat.service

install -v -m 0644 "$FILE_FOLDER"/socketcan-interface0.service "/etc/systemd/system/socketcan-interface0.service"
install -v -m 0644 "$FILE_FOLDER"/socketcan-interface1.service "/etc/systemd/system/socketcan-interface1.service"

systemctl disable socketcan-interface0.service
systemctl disable socketcan-interface1.service
