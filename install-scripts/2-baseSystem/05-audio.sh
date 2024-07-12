#!/bin/bash -e

usermod -a -G audio user

# TODO:
exit 0

apt-get -y -q install pulseaudio pulseaudio-module-bluetooth

echo "set-default-source alsa_output.platform-bcm2835_audio.analog-mono.2.monitor" >> /etc/pulse/default.pa
echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1" >> /etc/pulse/default.pa
