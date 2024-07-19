#!/bin/bash -e

## Create pypilot user to run the services.
if [ ! -d /home/pypilot ]; then
	echo "Creating pypilot user"
	adduser --home /home/pypilot --gecos --system --disabled-password --disabled-login pypilot
	chmod 775 /home/pypilot
fi

usermod -a -G tty pypilot
usermod -a -G i2c pypilot
usermod -a -G spi pypilot
usermod -a -G gpio pypilot
usermod -a -G dialout pypilot
usermod -a -G plugdev pypilot
usermod -a -G pypilot user

# Op way
apt-get install -y -q --no-install-recommends --no-install-suggests \
  git gcc python3 python3-pip python3-dev python3-setuptools libpython3-dev \
  python3-wheel python3-numpy python3-scipy python3-apt python3-requests \
  swig python3-ujson libjpeg62-turbo \
  python3-serial python3-pyudev python3-pil python3-flask python3-engineio \
  python3-opengl python3-wxgtk4.0 libwxgtk3.2-1=3.2.2+dfsg-2 libgles1 \
  libffi-dev python3-gevent python3-zeroconf watchdog lirc gpiod lm-sensors ir-keytable \
  python3-rpi.gpio gettext python3-flask-babel \
  libelf1 libftdi1-2 libhidapi-libusb0 libusb-0.1-4 libusb-1.0-0 \
  meson cmake make acl avrdude # https://kingtidesailing.blogspot.com/2016/02/how-to-setup-mpu-9250-on-raspberry-pi_25.html
  # octave

systemctl disable watchdog
systemctl disable lircd

usermod -a -G lirc user
usermod -a -G lirc pypilot

install -v -m 0644 "$FILE_FOLDER"/60-watchdog.rules "/etc/udev/rules.d/60-watchdog.rules"

# performance of the build, make parallel jobs
export MAKEFLAGS='-j 4'

apt-get install -y -q python3-pywavefront python3-pyglet python3-gps python3-gevent-websocket \
    python3-websocket python3-importlib-metadata \
    python3-socketio python3-flask-socketio

pip3 install --break-system-packages wmm2020 scipy inotify

## Give permission to sudo chrt without a password for the user pypilot.
{
  echo ""
  echo 'pypilot ALL=(ALL) NOPASSWD: /usr/bin/chrt'
  echo 'pypilot ALL=(ALL) NOPASSWD: /usr/bin/stty'
  echo 'user ALL=(ALL) NOPASSWD: /usr/local/sbin/pypilot-restart'
} >>/etc/sudoers

pushd ./stageCache
  # Install RTIMULib2 as it's a dependency of pypilot
  if [[ ! -d ./RTIMULib2 ]]; then
    git clone --depth=1 https://github.com/seandepagnier/RTIMULib2
  fi
  echo "Build and install RTIMULib2"

  pushd ./RTIMULib2/Linux/RTIMULibCal
    curl -o Makefile https://raw.githubusercontent.com/bareboat-necessities/my-bareboat/master/RTIMULibCal/Makefile
    make -j 4
    cp Output/RTIMULibCal /usr/local/bin/
    make clean
    install -v -o user -g pypilot -m 0775 -d "/home/user/kts"
    cp -r ../../RTEllipsoidFit /home/user/kts/
    #git clone --depth=1 https://github.com/bareboat-necessities/kts-scripts
    #cp -r kts-scripts /home/user/kts/scripts
    #rm -rf kts-scripts
    chown -R user:pypilot /home/user/kts
  popd

  pushd ./RTIMULib2/Linux/python
    python3 setup.py install
    python3 setup.py clean --all
  popd

#  apt-get install -yq python3-rtimulib2-pypilot

  echo "Get pypilot"
  if [[ ! -d ./pypilot ]]; then
    git clone https://github.com/pypilot/pypilot.git
    cd pypilot
    git checkout f74400ad1b9613b3de8adc138e156966c95d4289 # Jul 11, 2024
    cd ..
    git clone --depth=1 https://github.com/pypilot/pypilot_data.git
    cp -rv ./pypilot_data/* ./pypilot
    rm -rf ./pypilot_data
    pushd ./pypilot
      sed -i 's/from importlib.metadata/from importlib_metadata/' dependencies.py || true
      python3 setup.py build
    popd
  fi
  pushd /usr/local/lib/python3.11/dist-packages/wmm2020
    mkdir build
    cd build
    cmake ..
    make -j 4
    rm -f "$(find . -name \*.o)"
    cd ..
  popd
  ## Build and install pypilot
  pushd ./pypilot
    python3 setup.py install
    python3 setup.py clean --all
  popd
popd

## Install the service files
install -v -m 0644 "$FILE_FOLDER"/pypilot@.service "/etc/systemd/system/"
install -v -m 0644 "$FILE_FOLDER"/pypilot_boatimu.service "/etc/systemd/system/"
install -v -m 0644 "$FILE_FOLDER"/pypilot_web.service "/etc/systemd/system/"
install -v -m 0644 "$FILE_FOLDER"/pypilot_hat.service "/etc/systemd/system/"

sed -i 's/_http._tcp.local./_signalk-http._tcp.local./' "$(find /usr/local/lib -name signalk.py)" || true
#sed -i 's/ttyAMA0/serial1/' "$(find /usr/local/lib -name serialprobe.py)" || true
#sed -i "s/'ttyAMA'//" "$(find /usr/local/lib -name serialprobe.py)" || true

sed -i 's/from OpenGL.GLUT import */#from OpenGL.GLUT import */' "$(find /usr/local/lib -name autopilot_calibration.py)" || true
sed -i 's/glutInit(sys.argv)/#glutInit(sys.argv)/' "$(find /usr/local/lib -name autopilot_calibration.py)" || true
sed -i 's/BoatPlot = wx.glcanvas.GLCanvas(self.m_panel3/BoatPlot = wx.glcanvas.GLCanvas(self.m_panel4/' "$(find /usr/local/lib -name autopilot_control_ui.py)" || true

#cp "$FILE_FOLDER"/wind.py "$(find /usr/local/lib -name wind.py)" || true

patch "$(find /usr/local/lib -name autopilot_calibration.py)" "$FILE_FOLDER"/autopilot_calibration.patch || true

systemctl disable pypilot_boatimu.service
systemctl disable pypilot_hat.service
systemctl enable pypilot@pypilot.service                               # listens on tcp 20220 and 23322
systemctl enable pypilot_web.service                                   # listens on tcp 8080

## Install the user config files
install -v -o pypilot -g pypilot -m 0775 -d "/home/pypilot/.pypilot"
install -v -o pypilot -g pypilot -m 0775 -d "/home/pypilot/.pypilot/ugfxfonts"
install -v -o pypilot -g pypilot -m 0775 -d "/home/tc"
ln -s /home/pypilot/.pypilot "/home/user/.pypilot"
ln -s /home/pypilot/.pypilot "/home/tc/.pypilot"
setfacl -d -m g:pypilot:rw "/home/pypilot"
setfacl -d -m g:pypilot:rw "/home/pypilot/.pypilot"
setfacl -d -m g:pypilot:rw "/home/pypilot/.pypilot/ugfxfonts"
setfacl -d -m g:pypilot:rw "/home/tc"

install -v -o pypilot -g pypilot -m 0664 "$FILE_FOLDER"/signalk.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0664 "$FILE_FOLDER"/webapp.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0664 "$FILE_FOLDER"/pypilot_client.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0664 "$FILE_FOLDER"/pypilot.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0664 "$FILE_FOLDER"/hat.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0664 "$FILE_FOLDER"/blacklist_serial_ports "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0664 "$FILE_FOLDER"/serial_ports "/home/pypilot/.pypilot/serial_ports.sample"
install -v -o pypilot -g pypilot -m 0664 "$FILE_FOLDER"/servodevice "/home/pypilot/.pypilot/servodevice.sample"
install -v -o pypilot -g pypilot -m 0664 "$FILE_FOLDER"/nmea0device "/home/pypilot/.pypilot/nmea0device.sample"


if [[ -f /home/pypilot/.pypilot/pypilot.conf ]]; then
  chmod 664 /home/pypilot/.pypilot/pypilot.conf
  chown pypilot:pypilot /home/pypilot/.pypilot/pypilot.conf
fi

install -v -g pypilot -m 0664 "$FILE_FOLDER"/lircd.conf "/etc/lirc/lircd.conf.d/lircd-pypilot.conf"

install -m 755 "$FILE_FOLDER"/pypilot-restart "/usr/local/sbin/pypilot-restart"

# prevent pypilot from changing port
sed -i 's/8000/8080/' /etc/systemd/system/pypilot_web.service || true

# TODO: temp patch
install -m 644 "$FILE_FOLDER"/wind.py "$(find /usr/local/lib -name wind.py)"

# TODO: not needed after changing pypilot service working directory
echo > /RTIMULib.ini
chown pypilot:pypilot /RTIMULib.ini
chmod 664 /RTIMULib.ini

ln -s /etc/avrdude.conf /usr/local/etc/avrdude.conf


# See: https://forums.raspberrypi.com/viewtopic.php?t=359742
#apt-get -y remove python3-rpi.gpio
pip3 install --break-system-packages rpi-lgpio
