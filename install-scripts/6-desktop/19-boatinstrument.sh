#!/bin/bash -e

install -d -o 1000 -g 1000 /home/user/Documents/
install -o 1000 -g 1000 -v "$FILE_FOLDER"/boatinstrument.json "/home/user/Documents/boatinstrument.json"
install -o 1000 -g 1000 -v "$FILE_FOLDER"/boatinstrument.json "/home/user/Documents/boatinstrument.json-bbn"
install -o 1000 -g 1000 -v "$FILE_FOLDER"/boatinstrument.desktop /home/user/.local/share/applications/boatinstrument.desktop

BK_DIR="$(pwd)"

cd /home/user

wget -O boatinstrument.tgz https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/boatinstrument-0.6.0.6-linux-aarch64.tgz
gzip -cd < boatinstrument.tgz | tar xvf -
chown -R user:user ./boatinstrument/
rm -f boatinstrument.tgz

cd "$BK_DIR"

install -o 1000 -g 1000 -m 644 -v "$FILE_FOLDER"/boatinstrument.desktop "/home/user/.config/autostart/"
