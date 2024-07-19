#!/bin/bash -e

## Create signalk user to run the server.
if [ ! -d /home/signalk ]; then
	echo "Creating signalk user"
	adduser --home /home/signalk --gecos --system --disabled-password --disabled-login signalk
fi

usermod -a -G tty signalk
usermod -a -G i2c signalk
usermod -a -G spi signalk
usermod -a -G gpio signalk
usermod -a -G dialout signalk
usermod -a -G plugdev signalk
usermod -a -G lirc signalk

## Create the charts group and add users that have to write to that folder.
if ! grep -q charts /etc/group; then
	groupadd charts
	usermod -a -G charts signalk
	usermod -a -G charts user
	usermod -a -G charts root
fi

## Give set-system-time the possibility to change the date.
echo "signalk ALL=(ALL) NOPASSWD: /bin/date" >>/etc/sudoers

echo "" >>/etc/sudoers
echo 'user ALL=(ALL) NOPASSWD: /usr/local/sbin/signalk-restart' >>/etc/sudoers

## Create the special charts folder.
install -v -d -m 6775 -o signalk -g charts /srv/charts

## Link the chart folder to home for convenience.
if [ ! -f /home/user/charts ] ; then
	su user -c "ln -s /srv/charts /home/user/charts"
fi

## Dependencies of signalk.
apt-get install -y -q python3-dev git nodejs npm \
 libnss-mdns avahi-utils \
 node-abstract-leveldown node-nan libzmq3-dev libkrb5-dev libavahi-compat-libdnssd-dev

install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/plugin-config-data"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/node_modules/"

install -m 644 -o signalk -g signalk "$FILE_FOLDER"/set-system-time.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk "$FILE_FOLDER"/sk-to-nmea0183.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk "$FILE_FOLDER"/signalk-path-filter.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk "$FILE_FOLDER"/derived-data.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk "$FILE_FOLDER"/charts.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk "$FILE_FOLDER"/signalk-navtex-plugin.json "/home/signalk/.signalk/plugin-config-data/"

install -m 644 -o signalk -g signalk "$FILE_FOLDER"/defaults.json "/home/signalk/.signalk/defaults.json"
install -m 644 -o signalk -g signalk "$FILE_FOLDER"/package.json "/home/signalk/.signalk/package.json"
install -m 644 -o signalk -g signalk "$FILE_FOLDER"/settings.json "/home/signalk/.signalk/settings.json"
install -m 755 -o signalk -g signalk "$FILE_FOLDER"/signalk-server "/home/signalk/.signalk/signalk-server"
install -m 755 "$FILE_FOLDER"/signalk-restart "/usr/local/sbin/signalk-restart"

install -d /etc/systemd/system
install -m 644 "$FILE_FOLDER"/signalk.service "/etc/systemd/system/signalk.service"

## Install signalk
npm cache clean --force
npm install -g npm pnpm patch-package
npm install -g --unsafe-perm --production signalk-server

pushd /home/signalk/.signalk
  su signalk --shell=/bin/bash -c "export MAKEFLAGS='-j 8'; \
               export NODE_ENV=production; \
               pnpm install \
               @signalk/charts-plugin  \
               freeboard-sk-helper  \
               signalk-venus-plugin  \
               signalk-mqtt-gw  \
               signalk-mqtt-home-asisstant  \
               @codekilo/signalk-modbus-client  \
               signalk-derived-data  \
               signalk-anchoralarm-plugin  \
               signalk-alarm-silencer  \
               signalk-simple-notifications  \
               signalk-wilhelmsk-plugin  \
               signalk-to-nmea2000  \
               @signalk/signalk-autopilot  \
               @rakwireless/shtc3 \
               signalk-sonoff-ewelink  \
               signalk-fusion-stereo  \
               signalk-barometer-trend  \
               signalk-barograph \
               signalk-polar \
               signalk-scheduler \
               openweather-signalk \
               signalk-noaa-weather \
               xdr-parser-plugin \
               nmea0183-to-nmea0183 \
               signalk-path-filter \
               signalk-empirbusnxt-plugin \
               obd2-signalk \
               signalk-n2k-switch-alias \
               signalk-n2k-switching \
               signalk-n2k-switching-emulator \
               signalk-n2k-switching-translator \
               signalk-n2k-virtual-switch \
               signalk-switch-automation \
               signalk-shelly \
               @signalk/calibration \
               signalk-datetime \
               signalk-net-relay \
               signalk-path-mapper \
               signalk-healthcheck \
               @signalk/vedirect-serial-usb \
               @signalk/udp-nmea-plugin \
               signalk-n2kais-to-nmea0183 \
               @codekilo/nmea0183-iec61121-450-server \
               signalk-generic-pgn-parser \
               signalk-maretron-proprietary \
               @codekilo/signalk-notify \
               @codekilo/signalk-trigger-event \
               @codekilo/signalk-twilio-notifications \
               @meri-imperiumi/signalk-audio-notifications \
               signalk-buddylist-plugin \
               signalk-navtex-plugin \
               @meri-imperiumi/signalk-autostate \
               @meri-imperiumi/signalk-alternator-engine-on \
               signalk-saillogger --unsafe-perm --loglevel error"

#               signalk-to-influxdb \
#               @signalk/sailgauge  \
#               @signalk/tracks-plugin \
#               @signalk/signalk-node-red  \
#               node-red-dashboard \
#               node-red-contrib-nmea \
#               node-red-contrib-modbus \
#               @victronenergy/node-red-contrib-victron \
#               node-red-contrib-influxdb \
#               node-red-contrib-moment \
#               node-red-contrib-string \
#               node-red-node-email \
#               node-red-node-serialport \
#               node-red-node-openweathermap \
#               node-red-contrib-dht-sensor \
#               node-red-contrib-ds18b20-sensor \
#               node-red-contrib-sht31 \
#               node-red-contrib-bme280 \
#               node-red-contrib-sensor-htu21d \
#               node-red-contrib-ina-sensor \

sed -i 's#@signalk/server-admin-ui#admin#' "$(find /usr/local/lib/node_modules/signalk-server -name tokensecurity.js)" || true

# see https://github.com/SignalK/signalk-server/pull/1455/
#sed -i 's/\(filter(.*\]\)/"".join\(\1\)/'  "$(find /usr/local/lib/node_modules/signalk-server -name pigpio-seatalk.js)" || true

# use pnpm instead of npm
sed -i 's#('"'npm',#\('pnpm'"',#' /usr/local/lib/node_modules/signalk-server/lib/modules.js

# SignalK fix for pnpm
sed -i -e s/--save"'",/"--save-prod'",/g /usr/local/lib/node_modules/signalk-server/lib/modules.js

## Make some space on the drive for the next stages
npm cache clean --force

# For Seatalk
wget -q -O - https://raw.githubusercontent.com/MatsA/seatalk1-to-NMEA0183/master/STALK_read.py > /usr/local/sbin/STALK_read.py

systemctl enable signalk

rm -rf /home/signalk/.cache
rm -rf /home/signalk/.npm
rm -rf /home/signalk/.node-*


# See https://github.com/allinurl/gwsocket
wget http://tar.gwsocket.io/gwsocket-0.3.tar.gz
tar -xzvf gwsocket-0.3.tar.gz
cd gwsocket-0.3/
./configure
make -j 4
make install
cd ..
rm -rf gwsocket-0.3/ gwsocket-0.3.tar.gz

# Usage example:
#gwsocket -p 7474 --pipein=out  &
#socat - TCP4:localhost:10110 >> out  &
#wsdump -r ws://localhost:7474/



