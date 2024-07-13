#!/bin/bash -e

#TODO
exit 0

apt-get install -y --no-install-recommends --no-install-suggests \
  python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev libjpeg-dev \
  zlib1g-dev autoconf build-essential libopenjp2-7 libtiff6 libturbojpeg0 tzdata libsqlite3-dev

mkdir libffi-tmp && cd libffi-tmp
wget "https://github.com/libffi/libffi/releases/download/v3.3/libffi-3.3.tar.gz"
tar zxf libffi-3.3.tar.gz
cd libffi-3.3
./configure
make -j 4 install
ldconfig
cd ../..
rm -rf libffi-tmp

useradd -rm homeassistant -G dialout,gpio,i2c

mkdir -p /srv/homeassistant
chown homeassistant:homeassistant /srv/homeassistant

mkdir -p /home/homeassistant
chown homeassistant:homeassistant /home/homeassistant

su homeassistant --shell=/bin/bash -c "
  cd /srv/homeassistant;
  python3.11 -m venv . ;
  source bin/activate;
  python3.11 -m pip install wheel;
  pip3.11 install homeassistant sqlalchemy fnvhash setuptools pyotp PyQRCode;
  mkdir -p /home/homeassistant/.homeassistant;
  rm -rf /home/homeassistant/.cache"


bash -c 'cat << EOF > /etc/systemd/system/home-assistant@homeassistant.service
[Unit]
Description=Home Assistant
After=network-online.target
[Service]
Type=simple
User=%i
WorkingDirectory=/home/%i/.homeassistant
ExecStart=/srv/homeassistant/bin/hass -c "/home/%i/.homeassistant"

[Install]
WantedBy=multi-user.target
EOF'

systemctl disable home-assistant@homeassistant

######################## HomeAssistant Integrations

git clone --depth 1 https://github.com/SmartBoatInnovations/ha-smart0183tcp
cp -r ha-smart0183tcp/custom_components/smart0183tcp/ /home/homeassistant/.homeassistant/
chown -R homeassistant:homeassistant /home/homeassistant/.homeassistant/smart0183tcp/
rm -rf ha-smart0183tcp

git clone --depth 1 https://github.com/SmartBoatInnovations/ha-smart2000esp
cp -r ha-smart2000esp/custom_components/smart2000esp/ /home/homeassistant/.homeassistant/
chown -R homeassistant:homeassistant /home/homeassistant/.homeassistant/smart2000esp/
rm -rf ha-smart2000esp

git clone --depth 1 https://github.com/SmartBoatInnovations/ha-smart2000usb
cp -r ha-smart2000usb/custom_components/smart2000usb/ /home/homeassistant/.homeassistant/
chown -R homeassistant:homeassistant /home/homeassistant/.homeassistant/smart2000usb/
rm -rf ha-smart2000usb




