#!/bin/bash -e

# TODO:
exit 0

apt-get -y -q install raspotify

#if [ $LMARCH == 'armhf' ]; then
#  wget https://github.com/dtcooper/raspotify/releases/download/0.42.1/raspotify_0.42.1.librespot.v0.4.2-6537c44_armhf.deb -O rasp.deb
#fi
#if [ $LMARCH == 'arm64' ]; then
#  wget https://github.com/dtcooper/raspotify/releases/download/0.42.1/raspotify_0.42.1.librespot.v0.4.2-6537c44_arm64.deb -O rasp.deb
#fi
#dpkg -i rasp.deb && rm -f rasp.deb

if ! grep -q raspotify /etc/group; then
  groupadd raspotify
fi
usermod -a -G raspotify user
systemctl disable raspotify
install -d -m 755 -o 1000 -g 1000 "/home/user/.config/systemd/"
install -d -m 755 -o 1000 -g 1000 "/home/user/.config/systemd/user/"
install -v -m 644 -o 1000 -g 1000 "$FILE_FOLDER"/raspotify.service "/home/user/.config/systemd/user/raspotify.service"

apt-get clean

pip3 install --upgrade spotify-cli

#apt-mark hold raspotify
