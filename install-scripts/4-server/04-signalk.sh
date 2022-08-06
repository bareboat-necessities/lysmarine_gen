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

## Create the special charts folder.
install -v -d -m 6775 -o signalk -g charts /srv/charts

## Link the chart folder to home for convenience.
if [ ! -f /home/user/charts ] ; then
	su user -c "ln -s /srv/charts /home/user/charts"
fi


## Dependencies of signalk.
apt-get install -y -q python-dev git nodejs \
 libnss-mdns avahi-utils \
 node-abstract-leveldown node-nan libzmq3-dev libkrb5-dev libavahi-compat-libdnssd-dev jq

install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/plugin-config-data"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/node_modules/"

install -m 644 -o signalk -g signalk $FILE_FOLDER/set-system-time.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk $FILE_FOLDER/sk-to-nmea0183.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk $FILE_FOLDER/signalk-path-filter.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk $FILE_FOLDER/derived-data.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk $FILE_FOLDER/charts.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk $FILE_FOLDER/signalk-navtex-plugin.json "/home/signalk/.signalk/plugin-config-data/"

install -m 644 -o signalk -g signalk $FILE_FOLDER/defaults.json "/home/signalk/.signalk/defaults.json"
install -m 644 -o signalk -g signalk $FILE_FOLDER/package.json "/home/signalk/.signalk/package.json"
install -m 644 -o signalk -g signalk $FILE_FOLDER/settings.json "/home/signalk/.signalk/settings.json"
install -m 755 -o signalk -g signalk $FILE_FOLDER/signalk-server "/home/signalk/.signalk/signalk-server"
install -m 755 $FILE_FOLDER/signalk-restart "/usr/local/sbin/signalk-restart"

install -d -o signalk -g signalk "/home/user/.local/share/icons/"
install -m 644 -o 1000 -g 1000 $FILE_FOLDER/icons/signalk.png "/home/user/.local/share/icons/"

install -d /etc/systemd/system
install -m 644 $FILE_FOLDER/signalk.service "/etc/systemd/system/signalk.service"

# performance of the build, make parallel jobs
export MAKEFLAGS='-j 8'

## Install signalk
npm cache clean --force
npm install -g pnpm

## Install signalk published plugins
pushd /home/signalk/.signalk
  su signalk -c "export MAKEFLAGS='-j 8'; \
                 pnpm install signalk-server \
                 @signalk/charts-plugin  \
                 sk-resources-fs  \
                 freeboard-sk-helper  \
                 skwiz  \
                 tuktuk-chart-plotter  \
                 signalk-raspberry-pi-bme280  \
                 signalk-raspberry-pi-bmp180  \
                 signalk-raspberry-pi-ina219  \
                 signalk-raspberry-pi-1wire  \
                 signalk-raspberry-mcs  \
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
                 @signalk/sailgauge  \
                 @signalk/signalk-autopilot  \
                 @signalk/signalk-node-red  \
                 node-red-dashboard \
                 node-red-contrib-nmea \
                 node-red-contrib-modbus \
                 node-red-contrib-solaredge-modbus \
                 @victronenergy/node-red-contrib-victron \
                 node-red-contrib-influxdb \
                 node-red-contrib-moment \
                 node-red-contrib-string \
                 node-red-node-email \
                 node-red-node-openweathermap \
                 signalk-sonoff-ewelink  \
                 signalk-raspberry-pi-monitoring  \
                 @mxtommy/kip  \
                 signalk-fusion-stereo  \
                 signalk-barometer-trend  \
                 @oehoe83/signalk-raspberry-pi-bme680  \
                 signalk-threshold-notifier  \
                 signalk-barograph \
                 signalk-polar \
                 signalk-scheduler \
                 signalk-sbd signalk-sbd-msg \
                 openweather-signalk \
                 signalk-noaa-weather \
                 xdr-parser-plugin \
                 signalk-to-influxdb \
                 nmea0183-to-nmea0183 \
                 signalk-path-filter \
                 signalk-empirbusnxt-plugin \
                 signalk-n2k-switch-alias \
                 signalk-n2k-switching \
                 signalk-n2k-switching-emulator \
                 signalk-n2k-switching-translator \
                 signalk-n2k-virtual-switch \
                 signalk-switch-automation \
                 signalk-shelly \
                 @signalk/calibration \
                 @signalk/tracks-plugin \
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
                 signalk-vessels-to-ais \
                 @codekilo/signalk-notify \
                 @codekilo/signalk-trigger-event \
                 @codekilo/signalk-twilio-notifications \
                 @meri-imperiumi/signalk-audio-notifications \
                 signalk-buddylist-plugin \
                 signalk-navtex-plugin \
                 @meri-imperiumi/signalk-autostate \
                 @meri-imperiumi/signalk-alternator-engine-on \
                 signalk-saillogger --unsafe-perm --loglevel error"
popd

sed -i "s#sudo ##g" /home/signalk/.signalk/node_modules/signalk-raspberry-pi-monitoring/index.js
sed -i "s#/opt/vc/bin/##g" /home/signalk/.signalk/node_modules/signalk-raspberry-pi-monitoring/index.js
sed -i 's#@signalk/server-admin-ui#admin#' "$(find /usr/lib/node_modules/signalk-server -name tokensecurity.js)" || true

## Give set-system-time the possibility to change the date.
echo "signalk ALL=(ALL) NOPASSWD: /bin/date" >>/etc/sudoers

## Make some space on the drive for the next stages
npm cache clean --force

# For Seatalk
apt-get install -y -q pigpio python-pigpio python3-pigpio python3-rpi.gpio
systemctl disable pigpiod

# For Seatalk
wget -q -O - https://raw.githubusercontent.com/MatsA/seatalk1-to-NMEA0183/master/STALK_read.py > /usr/local/sbin/STALK_read.py

echo "" >>/etc/sudoers
echo 'user ALL=(ALL) NOPASSWD: /usr/local/sbin/signalk-restart' >>/etc/sudoers

systemctl enable signalk

sudo bash -c 'cat << EOF > /usr/local/share/applications/signalk-node-red.desktop
[Desktop Entry]
Type=Application
Name=SignalK-Node-Red
GenericName=SignalK-Node-Red
Comment=SignalK-Node-Red
Exec=gnome-www-browser http://localhost:3000/@signalk/signalk-node-red
Terminal=false
Icon=gtk-no
Categories=Utility;
EOF'

sudo bash -c 'cat << EOF > /usr/local/share/applications/signalk-polar.desktop
[Desktop Entry]
Type=Application
Name=SignalK-Polar
GenericName=SignalK-Polar
Comment=SignalK-Polar
Exec=gnome-www-browser http://localhost:3000/signalk-polar
Terminal=false
Icon=gtk-about
Categories=Utility;
EOF'

bash -c 'cat << EOF > /usr/local/bin/gps-loc
#!/bin/bash
curl -s http://localhost:3000/signalk/v1/api/vessels/self/navigation/position/ | jq -M -jr '\''.value.latitude," ",.value.longitude','" ",.timestamp'\''
EOF'
chmod +x /usr/local/bin/gps-loc

rm -rf /home/signalk/.cache
rm -rf /home/signalk/.npm
rm -rf /home/signalk/.node-*


