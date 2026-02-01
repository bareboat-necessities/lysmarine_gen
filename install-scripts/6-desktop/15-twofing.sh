#!/bin/bash -e

# See http://plippo.de/dev_twofing
# and https://github.com/Plippo/twofing
# and https://github.com/sjlongland/twofing

apt-get -y install --no-install-recommends --no-install-suggests \
  build-essential libx11-dev libxtst-dev libxi-dev x11proto-randr-dev libxrandr-dev \
  xserver-xorg-input-evdev-dev xserver-xorg-input-evdev git # udev/trixie-backports

git clone --depth=1 https://github.com/bareboat-necessities/twofing.git

cd twofing || exit 255
make -j 5 && cp twofing /usr/local/bin/
cd .. && rm -rf twofing

bash -c 'cat << EOF > /etc/udev/rules.d/70-touchscreen.rules
SUBSYSTEMS=="input", KERNEL=="event[0-9]*", ENV{ID_INPUT_TOUCHSCREEN}=="1", SYMLINK+="touchscreen%n"
SUBSYSTEMS=="input", KERNEL=="event[0-9]*", ENV{ID_INPUT_TOUCHSCREEN}=="1", SYMLINK+="twofingtouch", RUN+="/bin/chmod a+r /dev/twofingtouch"
EOF'

bash -c 'cat << EOF > /etc/udev/rules.d/99-input-tagging.rules
ACTION=="add", KERNEL=="event*", SUBSYSTEM=="input", TAG+="systemd", , ENV{SYSTEMD_ALIAS}+="/sys/subsystem/input/devices/$env{ID_SERIAL}"
EOF'

