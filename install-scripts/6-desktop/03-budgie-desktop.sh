#!/bin/bash -e

apt-get install -y -q --no-install-recommends --no-install-suggests \
  gvfs-fuse gvfs-backends gnome-bluetooth gnome-weather \
  lightdm lightdm-autologin-greeter # added lightdm due to https://github.com/BuddiesOfBudgie/budgie-desktop/issues/508

apt-get install -y -q geoclue-2-demo ibus

#  libatk-adaptor libgtk-4-1 libatk1.0-0 libcairo2 libfontconfig1 libfreetype6 \
#  libgdk-pixbuf2.0-0 libglib2.0-0  \
#  libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 librsvg2-common libx11-6

install -o 1000 -g 1000 -d /home/user/.config/openbox

## Start budgie-desktop boot.
install -o 1000 -g 1000 -m 644 -v "$FILE_FOLDER"/.xinitrc    "/home/user/"

#echo '(chromium-browser --headless || true) &' >>/home/user/.config/openbox/autostart

apt-get clean

chmod 4775 /usr/bin/nm-connection-editor
#chmod 4775 /usr/bin/gnome-control-center

## Autostart openbox from budgie-desktop.
install -o 1000 -g 1000 -d /home/user/.config/autostart
#install -o 1000 -g 1000 -m 644 -v "$FILE_FOLDER"/openbox.desktop    "/home/user/.config/autostart/"
#install -o 1000 -g 1000 -m 644 -v "$FILE_FOLDER"/autostart.desktop  "/home/user/.config/autostart/"

# Budgie settings

{
  echo "dconf write /com/solus-project/budgie-wm/center-windows true"
  echo "dconf write /com/solus-project/budgie-wm/focus-mode false"
  echo "dconf write /org/gnome/desktop/wm/preferences/num-workspaces 1"
  echo "dconf load /org/onboard/ < /usr/share/onboard/onboard.dconf"
  echo "dconf load / < /usr/share/onboard/a11y.dconf"
  echo "dconf write /org/gnome/system/location/enabled true"
  echo "dconf write /org/gnome/desktop/interface/enable-animations false"
  echo "dconf write /org/gnome/desktop/interface/icon-theme \"'gnome'\""
  echo "dconf write /org/gnome/desktop/interface/overlay-scrolling false"
  echo "dconf write /org/gnome/desktop/background/picture-uri \"''\""
  echo "dconf write /org/gnome/Weather/automatic-location true"
  echo "dconf write /org/gnome/Weather/Application/automatic-location true"
  echo "dconf write /org/ubuntubudgie/plugins/weathershow/windunit \"'Miles'\""
  echo "dconf write /org/ubuntubudgie/plugins/weathershow/desktopweather false"
  echo "dconf write /org/gnome/desktop/screensaver/lock-enabled false"
  echo "dconf write /org/gnome/desktop/screensaver/lock-delay 'uint32 0'"
  echo "dconf write /org/gnome/desktop/session/idle-delay 'uint32 0'"
  echo "dconf write /org/gnome/calculator/refresh-interval 0"
} >> /home/user/.config/openbox/autostart

echo "sed -i 's/^dconf\ /#&/' /home/user/.config/openbox/autostart" >> /home/user/.config/openbox/autostart
echo "sed -i 's/^sed\ /#&/'   /home/user/.config/openbox/autostart" >> /home/user/.config/openbox/autostart

# LightDM autologin
groupadd -r autologin
gpasswd -a user autologin
sed -i 's/^#user-session=default/user-session=default/'  /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user=/autologin-user=user/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-session=/autologin-session=openbox/' /etc/lightdm/lightdm.conf

install -v -m644 "$FILE_FOLDER"/lightdm.service "/etc/systemd/system/lightdm.service"

# GeoClue
usermod -a -G geoclue user

install -o geoclue -g geoclue -d /var/lib/geoclue/.cache
install -o geoclue -g geoclue -d /var/lib/geoclue/.cache/dconf
chmod 775 /var/lib/geoclue/.cache/dconf

cat << EOF >> /etc/geoclue/geoclue.conf

[org.gnome.Weather]
allowed=true
system=false
users=

[org.gnome.clocks]
allowed=true
system=false
users=

[org.freedesktop.GeoClue2]
allowed=true
system=false
users=

EOF
