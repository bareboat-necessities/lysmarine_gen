#!/bin/bash -e

wget https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/kplex_1.4.1.3_armhf.deb -O kplex.deb

dpkg -i kplex.deb && rm -f kplex.deb

install -v -o 1000 -g 1000 -m 0644 "$FILE_FOLDER"/kplex-bbn.conf "/etc/"
install -v -o 1000 -g 1000 -m 0644 "$FILE_FOLDER"/kplex-bbn.conf "/etc/kplex.conf"

systemctl enable kplex
