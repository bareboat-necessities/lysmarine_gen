#!/bin/bash -e

#apt-get -y update
#apt-mark hold linux-image-rpi-2712 linux-image-rpi-v8 linux-headers-rpi-2712 linux-headers-rpi-v8 linux-libc-dev
#apt-get -y upgrade
apt-get autoremove -y --purge
#apt-mark unhold linux-image-rpi-2712 linux-image-rpi-v8 linux-headers-rpi-2712 linux-headers-rpi-v8 linux-libc-dev

# https://github.com/bareboat-necessities/lysmarine_gen/issues/375
pip3 install scipy

# Clean up applications menu for budgie
overrideMenu() {
  category=$1
  desktopFile=$2
  if [ -f "$desktopFile" ]; then
    baseDesktopFile=$(basename "${desktopFile}")
    cp "$desktopFile" /home/user/.local/share/applications/"$baseDesktopFile"
    chown user:user /home/user/.local/share/applications/"$baseDesktopFile"
    sed -i "s/Categories=.*/Categories=$category/" /home/user/.local/share/applications/"$baseDesktopFile"
  fi
}

cat << EOF > /home/user/.local/share/desktop-directories/radio.directory
[Desktop Entry]
Name=Radio
Comment=Radio
Icon=arrow
Type=Directory
EOF
chown user:user /home/user/.local/share/desktop-directories/radio.directory

overrideMenu Office /usr/share/applications/org.kiwix.desktop.desktop
overrideMenu Office /usr/share/applications/thunderbird.desktop
overrideMenu Office /usr/share/applications/org.gnome.Calculator.desktop
overrideMenu Office /usr/share/applications/org.gnome.Todo.desktop
overrideMenu Office /usr/share/applications/org.gnome.clocks.desktop
overrideMenu Office /usr/share/applications/org.gnome.gedit.desktop
overrideMenu X-GNOME-Utilities /usr/share/applications/org.gnome.Evince-previewer.desktop
overrideMenu X-GNOME-Utilities /usr/share/applications/org.gnome.Evince.desktop
overrideMenu Office /usr/share/applications/org.gnome.eog.desktop
overrideMenu Office /usr/share/applications/system-config-printer.desktop
overrideMenu Utility /usr/local/share/applications/arduino-arduinoide.desktop
overrideMenu Utility /usr/local/share/applications/org.wxformbuilder.wxFormBuilder.desktop
overrideMenu X-GNOME-Utilities /usr/share/applications/sailcut.desktop
overrideMenu X-GNOME-Utilities /usr/share/applications/boats.desktop
overrideMenu X-GNOME-Utilities /usr/share/applications/org.gnome.seahorse.Application.desktop
overrideMenu System /usr/share/applications/onboard.desktop
overrideMenu Settings /usr/share/applications/onboard-settings.desktop
overrideMenu X-GNOME-Utilities /usr/share/applications/org.gnome.baobab.desktop
overrideMenu Radio /usr/share/applications/cutesdr.desktop
overrideMenu Radio /usr/share/applications/CubicSDR.desktop
overrideMenu Radio /usr/share/applications/gpredict.desktop
overrideMenu Radio /usr/share/applications/flarq.desktop
overrideMenu Radio /usr/share/applications/fldigi.desktop
overrideMenu Radio /usr/share/applications/dk.gqrx.gqrx.desktop
overrideMenu Radio /usr/local/share/applications/previsat.desktop
overrideMenu Radio /usr/share/applications/pc-navtex.desktop
overrideMenu Navigation /usr/share/applications/xygrib.desktop
overrideMenu Utility /root/Desktop/arduino-arduinoide.desktop

rm -rf  /tmp/empty-cache46
rm -rvf /home/user/Public /home/user/Templates 

# For systems with pipewire-pulse to make Mopidy sound work
if [ -f /usr/share/pipewire/pipewire-pulse.conf ]; then
  sed -i 's/#"tcp:4713"/"tcp:4713"/' /usr/share/pipewire/pipewire-pulse.conf
fi

apt-get clean

apt-get remove -y --purge greybird-gtk-theme murrine-themes rpd-icons userconf-pi gdb libsdl2-dev libicu-dev \
  libnorm-dev libavcodec-dev libfftw3-dev

if [ "$BBN_KIND" == "LITE" ] ; then
  apt-get remove -y --purge system-config-printer gnome-power-manager
  rm -f /usr/share/applications/thunar-bulk-rename.desktop
fi

apt-get -y autoremove
apt-get clean
npm cache clean --force || true
rm -rf ~/.local/share/pnpm

# remove python pip cache
rm -rf ~/.cache/pip

# remove all cache
rm -rf ~/.cache
rm -rf ~/.config
rm -rf ~/.npm
rm -rf ~/.wget*
rm -rf $(find /var/log/ -type f)
rm -f /opt/vc/src/hello_pi/hello_video/test.h264

rm -f /usr/share/applications/org.buddiesofbudgie.BudgieScreenshot.desktop

# speed up boot without ethernet plugged
rm -rf /etc/systemd/system/dhcpcd.service.d/wait.conf
systemctl disable systemd-networkd-wait-online.service
#systemctl disable NetworkManager-wait-online.service
#systemctl mask plymouth-quit-wait.service
install -v -d "/etc/systemd/system/networking.service.d"
bash -c 'cat << EOF > /etc/systemd/system/networking.service.d/reduce-timeout.conf
[Service]
TimeoutStartSec=8
EOF'
install -v -d "/etc/systemd/system/nmbd.service.d"
bash -c 'cat << EOF > /etc/systemd/system/nmbd.service.d/reduce-timeout.conf
[Service]
TimeoutStartSec=15
RestartSec=60
Restart=always
EOF'

echo '/usr/lib /usr/share /usr/include /usr/bin /srv' | xargs -n 1 -P 4 hardlink -v -t

if [ "$BBN_KIND" == "LITE" ] ; then
  true
else
  apt-get -q -y install --download-only avnav-update-plugin
fi

for f in /etc/apt/sources.list.d/bbn-*.list
do
  mv "$f" "$f"-orig
done

# These are launchpad. They are ok to have.
mv /etc/apt/sources.list.d/bbn-rce.list-orig /etc/apt/sources.list.d/bbn-rce.list || true
mv /etc/apt/sources.list.d/bbn-kplex.list-orig /etc/apt/sources.list.d/bbn-kplex.list || true

rm -f /etc/apt/sources.list.d/*.list-orig

install -v -m 0644 "$FILE_FOLDER"/rsyslog "/etc/logrotate.d/rsyslog"

# clean up more
rm -rf /usr/share/doc/noaa-apt/docs/examples/argentina.wav*
rm -rf /usr/share/doc/nodejs/api/
rm -rf /usr/share/doc/nodejs/changelogs/
rm -rf /usr/share/doc/tcllib/html/
rm -rf /usr/share/doc/openjdk*/test*/*
rm -rf /usr/share/doc/python3*/HISTORY.*
rm -rf /usr/share/doc/python3*/NEWS.*
rm -rf /usr/share/backgrounds/budgie/*
rm -rf /var/lib/apt/lists/*
rm -rf /usr/share/applications/*ts_calibrate*.desktop
rm -rf /usr/share/applications/*ts_test*.desktop
rm -f /2
find /usr/share/doc -name changelog\*.gz -exec rm -f {} \;
find /usr/share/doc -name NEWS\*.gz -exec rm -f {} \;

if [ "$BBN_KIND" == "LITE" ] ; then
  echo 1 > /etc/bbn-lite
fi

date --rfc-3339=seconds > /etc/bbn-build
fake-hwclock save

mkdir -p /home/user/Music || true
chown user:audio /home/user/Music

chown root:root /
chmod 755 /

rm -rf /boot/issue.txt
#install -v -m0644 "$FILE_FOLDER"/issue.txt "/boot/"
install -v -m0644 "$FILE_FOLDER"/firstrun.sh "/boot/"

rm -f /usr/share/applications/xgpsspeed.desktop
rm -f /usr/share/applications/xgps.desktop
rm -f /usr/share/applications/yad-icon-browser.desktop

sed -i 's/#RebootWatchdogSec=10min/RebootWatchdogSec=75s/' /etc/systemd/system.conf

# Fill free space with zeros
cat /dev/zero > /zer0s || true
rm -f /zer0s
