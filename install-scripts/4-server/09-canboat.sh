#!/bin/bash -e

apt-get -y -q install canboat can-utils dfu-util

yes | cpan install Config::General # for canboat n2kd_monitor

systemctl disable canboat.service

install -v -m 0644 "$FILE_FOLDER"/socketcan-interface.service "/etc/systemd/system/socketcan-interface.service"

systemctl disable socketcan-interface.service
