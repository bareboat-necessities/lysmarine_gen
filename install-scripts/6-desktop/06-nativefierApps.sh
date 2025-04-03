#!/bin/bash -e

apt-get clean

apt-get -y -q install nodejs libnss3 gnome-icon-theme unzip

npm install nativefier electron -g --unsafe-perm --production

## Install icons and .desktop files
install -d -o 1000 -g 1000 /home/user/.local/share/icons
install -v -o 1000 -g 1000 -m 644 "$FILE_FOLDER"/icons/signalk.png /home/user/.local/share/icons/
install -d /usr/local/share/applications

## arch name translation
if [ "$LMARCH" == 'armhf' ]; then
  arch=armv7l
elif [ "$LMARCH" == 'arm64' ]; then
  arch=arm64
elif [ "$LMARCH" == 'amd64' ]; then
  arch=x64
else
  arch=$LMARCH
fi

########################################################################################################################

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "bbn-launcher" --icon /usr/share/icons/gnome/256x256/apps/utilities-system-monitor.png \
  "http://localhost:4997" /opt/

nativefier -a "$arch" --inject "$FILE_FOLDER"/pypilot_darktheme.js --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "Pypilot_webapp" --icon /usr/share/icons/gnome/256x256/actions/go-jump.png \
  "http://localhost:8080" /opt/

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "SignalK" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:3000/admin/" /opt/

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "kip-dash" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:3000/@mxtommy/kip/" /opt/

install -v -m 0644 "$FILE_FOLDER"/pypilot_webapp.desktop "/usr/local/share/applications/"
install -v -m 0644 "$FILE_FOLDER"/signalk.desktop "/usr/local/share/applications/"
install -v -m 0644 "$FILE_FOLDER"/kip-dash.desktop "/usr/local/share/applications/"

mv /opt/bbn-launcher-linux-"$arch" /opt/bbn-launcher
mv /opt/Pypilot_webapp-linux-"$arch" /opt/Pypilot_webapp
mv /opt/SignalK-linux-"$arch" /opt/SignalK
mv /opt/kip-dash-linux-"$arch" /opt/kip-dash

## On debian, the sandbox environment fail without GUID/SUID
if [ "$LMOS" == Debian ]; then
  chmod 4755 /opt/bbn-launcher/chrome-sandbox
  chmod 4755 /opt/Pypilot_webapp/chrome-sandbox
  chmod 4755 /opt/SignalK/chrome-sandbox
  chmod 4755 /opt/kip-dash/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -t /opt/* /usr/lib/node_modules/electron/*
npm cache clean --force

apt-get clean

chmod 755 /opt/*

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

########################################################################################################################

install -v -o 1000 -g 1000 -m 644 "$FILE_FOLDER"/icons/freeboard-sk.png /home/user/.local/share/icons/
install -v -o 1000 -g 1000 -m 644 "$FILE_FOLDER"/icons/dockwa.png /home/user/.local/share/icons/

install -d '/usr/local/share/bbn-checklist'
install -v -m 0644 "$FILE_FOLDER"/bbn-checklist/asciidoctor.css "/usr/local/share/bbn-checklist/"
install -v -m 0644 "$FILE_FOLDER"/bbn-checklist/bbn-checklist.html "/usr/local/share/bbn-checklist/"
install -v -m 0644 "$FILE_FOLDER"/bbn-checklist/bareboat-necessities-logo.svg "/usr/local/share/bbn-checklist/"

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "AvNav" --icon /usr/share/icons/gnome/256x256/actions/go-jump.png \
  "http://localhost:8099/viewer/avnav_viewer.html?noCloseDialog=true" /opt/

install -v -m 0644 "$FILE_FOLDER"/avnav.desktop "/usr/local/share/applications/"

## Make folder name arch independent.
mv /opt/AvNav-linux-"$arch" /opt/AvNav

## On debian, the sandbox environment fail without GUID/SUID
if [ "$LMOS" == Debian ]; then
  chmod 4755 /opt/AvNav/chrome-sandbox
fi

########################################################################################################################

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "Freeboard-sk" --icon /home/user/.local/share/icons/freeboard-sk.png \
  "http://localhost:3000/@signalk/freeboard-sk/" /opt/

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "instrumentpanel" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:3000/@signalk/instrumentpanel/" /opt/

#nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
#  --disable-old-build-warning-yesiknowitisinsecure \
#  --name "sailgauge" --icon /home/user/.local/share/icons/signalk.png \
#  "http://localhost:3000/@signalk/sailgauge/" /opt/

install -v "$FILE_FOLDER"/Freeboard-sk.desktop /usr/local/share/applications/
install -v "$FILE_FOLDER"/instrumentpanel.desktop /usr/local/share/applications/
#install -v "$FILE_FOLDER"/sailgauge.desktop /usr/local/share/applications/

## Make folder name arch independent.
mv /opt/Freeboard-sk-linux-"$arch" /opt/Freeboard-sk
mv /opt/instrumentpanel-linux-"$arch" /opt/instrumentpanel
#mv /opt/sailgauge-linux-"$arch" /opt/sailgauge

## On debian, the sandbox environment fail without GUID/SUID
if [ "$LMOS" == Debian ]; then
  chmod 4755 /opt/Freeboard-sk/chrome-sandbox
  chmod 4755 /opt/instrumentpanel/chrome-sandbox
  #chmod 4755 /opt/sailgauge/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -t /opt/* /usr/lib/node_modules/electron/*
npm cache clean --force

########################################################################################################################

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "MusicBox" --icon /usr/share/icons/gnome/48x48/apps/multimedia-volume-control.png \
  --internal-urls ".*" \
  "http://localhost:6680/musicbox_webclient" /opt/

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "Iris" --icon /usr/share/icons/gnome/48x48/apps/multimedia-volume-control.png \
  --internal-urls ".*" \
  "http://localhost:6680/iris" /opt/

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "Moorings" --icon /home/user/.local/share/icons/dockwa.png \
  --internal-urls ".*" \
  "http://localhost:4997/www?name=moorings" /opt/

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "Nauticed" --icon /usr/share/icons/gnome/256x256/actions/go-jump.png \
  --internal-urls ".*" \
  "http://localhost:4997/www?name=nauticed" /opt/

mv /opt/MusicBox-linux-"$arch" /opt/MusicBox
mv /opt/Iris-linux-"$arch" /opt/Iris
mv /opt/Moorings-linux-"$arch" /opt/Moorings
mv /opt/Nauticed-linux-"$arch" /opt/Nauticed

install -m 644 "$FILE_FOLDER"/musicbox.desktop "/usr/local/share/applications/"
install -m 644 "$FILE_FOLDER"/iris.desktop "/usr/local/share/applications/"
install -m 644 "$FILE_FOLDER"/moorings.desktop "/usr/local/share/applications/"
install -m 644 "$FILE_FOLDER"/nauticed.desktop "/usr/local/share/applications/"

## On debian, the sandbox environment fail without GUID/SUID
if [ "$LMOS" == Debian ]; then
  chmod 4755 /opt/MusicBox/chrome-sandbox
  chmod 4755 /opt/Iris/chrome-sandbox
  chmod 4755 /opt/Moorings/chrome-sandbox
  chmod 4755 /opt/Nauticed/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -t /opt/* /usr/lib/node_modules/electron/*
npm cache clean --force

########################################################################################################################

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "youtube" --icon /usr/share/icons/gnome/48x48/apps/multimedia-volume-control.png \
  --internal-urls ".*" \
  "http://localhost:4997/www?name=youtube" /opt/

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "facebook" --icon /usr/share/icons/Adwaita/48x48/emotes/face-cool-symbolic.symbolic.png \
  --internal-urls ".*" \
  "http://localhost:4997/www?name=facebook" /opt/

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "WA-Web-Msg" --icon /usr/share/icons/Adwaita/48x48/emotes/face-monkey-symbolic.symbolic.png \
  --internal-urls ".*" \
  "http://localhost:4997/www?name=WA-Web-Msg" /opt/

mv /opt/youtube-linux-"$arch" /opt/youtube
mv /opt/facebook-linux-"$arch" /opt/facebook
mv /opt/WA-Web-Msg-linux-"$arch" /opt/WA-Web-Msg

install -v "$FILE_FOLDER"/youtube.desktop /usr/local/share/applications/
install -v "$FILE_FOLDER"/facebook.desktop /usr/local/share/applications/
install -v "$FILE_FOLDER"/WA-Web-Msg.desktop /usr/local/share/applications/

## On debian, the sandbox environment fail without GUID/SUID
if [ "$LMOS" == Debian ]; then
  chmod 4755 /opt/youtube/chrome-sandbox
  chmod 4755 /opt/facebook/chrome-sandbox
  chmod 4755 /opt/WA-Web-Msg/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -t /opt/* /usr/lib/node_modules/electron/*
npm cache clean --force

########################################################################################################################

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "motioneye" --icon /usr/share/icons/gnome/48x48/devices/camera-web.png \
  "http://localhost:8765/" /opt/

nativefier -a "$arch" --disable-context-menu --disable-dev-tools --single-instance \
  --disable-old-build-warning-yesiknowitisinsecure \
  --name "sk-autopilot" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:3000/@signalk/signalk-autopilot/" /opt/

install -v -m 0644 "$FILE_FOLDER"/motioneye.desktop "/usr/local/share/applications/"
install -v -m 0644 "$FILE_FOLDER"/sk-autopilot.desktop "/usr/local/share/applications/"

mv /opt/motioneye-linux-"$arch" /opt/motioneye
mv /opt/sk-autopilot-linux-"$arch" /opt/sk-autopilot

## On debian, the sandbox environment fail without GUID/SUID
if [ "$LMOS" == Debian ]; then
  chmod 4755 /opt/motioneye/chrome-sandbox
  chmod 4755 /opt/sk-autopilot/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -t /opt/* /usr/lib/node_modules/electron/*
npm cache clean --force

chmod 755 /opt/*

apt-get clean

