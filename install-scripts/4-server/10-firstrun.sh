#!/bin/bash -e

install -v -m 0755 "$FILE_FOLDER"/firstRun.sh "/usr/local/sbin/firstrun"
install -v -m 0644 "$FILE_FOLDER"/firstRun.service "/etc/systemd/system/"

systemctl enable firstRun.service
