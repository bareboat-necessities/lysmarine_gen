#!/bin/bash -e

install  -v "$FILE_FOLDER"/Xwrapper.config "/etc/X11/"  # Needed to allow the service file start X

apt-get -q -y install xserver-xorg-input-libinput xinput libinput-tools xinput-calibrator gldriver-test \
 budgie-desktop budgie-weathershow-applet budgie-rotation-lock-applet \
 gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav \
 gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-alsa v4l-utils \
 gstreamer1.0-libav alsa-utils libavahi-compat-libdnssd-dev git \
 xsettingsd xserver-xorg xserver-xorg-video-fbturbo \
 xinit cpanminus perl-base wmctrl openbox python3-xdg arandr gnome-clocks \
 dialog lxterminal network-manager-gnome system-config-printer \
 lxterminal gpsbabel file-roller lxtask thunar git \
 libqt5quickwidgets5 libqt5widgets5 libqt5gui5 libqt5webenginewidgets5 libqt5webengine-data \
 libqt5sql5 libqt5printsupport5 libqt5network5 libqt5serialport5 \
 libqt5svg5 libqt5opengl5 libqt5test5 libqt5xml5 libqt5qml5 qml-module-qtquick-controls libsndfile1 \
 chromium chromium-common chromium-sandbox rpi-chromium-mods \
 lxterminal gpsbabel file-roller lxtask thunar \
 libgtkmm-3.0-1t64 libglibmm-2.4-1t64 libatkmm-1.6-1v5 libpangomm-1.4-1v5 libcairomm-1.0-1v5

install -o 1000 -g 1000 -d /home/user/.local
install -o 1000 -g 1000 -d /home/user/.local/share
install -o 1000 -g 1000 -d /home/user/.local/share/desktop-directories
install -o 1000 -g 1000 -d /home/user/.local/share/applications
install -o 1000 -g 1000 -d /home/user/.local/share/icons
install -o 1000 -g 1000 -d /home/user/.local/share/sounds

# Openbox
install -o 1000 -g 1000 -d /home/user/.config
install -o 1000 -g 1000 -d /home/user/.config/openbox
install -o 1000 -g 1000 -v "$FILE_FOLDER"/autostart /home/user/.config/openbox/

# Thunar file manager
install -o 1000 -g 1000 -d /home/user/.config/xfce4
install -o 1000 -g 1000 -d /home/user/.config/xfce4/xfconf
install -o 1000 -g 1000 -d /home/user/.config/xfce4/xfconf/xfce-perchannel-xml
install -o 1000 -g 1000 -v "$FILE_FOLDER"/thunar.xml /home/user/.config/xfce4/xfconf/xfce-perchannel-xml/

# Menus
install -o 1000 -g 1000 -d /home/user/.config/menus
install -o 1000 -g 1000 -v "$FILE_FOLDER"/gnome-applications.menu /home/user/.config/menus/gnome-applications.menu-orig
install -o 1000 -g 1000 -v "$FILE_FOLDER"/lysmarine-applications.menu /home/user/.config/menus/lysmarine-applications.menu-orig
install -o 1000 -g 1000 -v "$FILE_FOLDER"/lysmarine-applications.menu /home/user/.config/menus/gnome-applications.menu
install -o 1000 -g 1000 -v "$FILE_FOLDER"/navigation.directory /home/user/.local/share/desktop-directories/
install -o 1000 -g 1000 -v "$FILE_FOLDER"/openplotter.directory /home/user/.local/share/desktop-directories/

if [ "$BBN_KIND" == "LITE" ] ; then
  install -m 755 -v "$FILE_FOLDER"/bbn-commands-lite.sh /usr/local/bin/bbn-commands
else
  install -m 755 -v "$FILE_FOLDER"/bbn-commands.sh /usr/local/bin/bbn-commands
fi

install -d /usr/local/share/applications
install -v "$FILE_FOLDER"/commands.desktop /usr/local/share/applications/

install -d /etc/budgie-desktop
install -m 644 -v "$FILE_FOLDER"/panel.ini /etc/budgie-desktop/

apt-get clean   # Make some room for the rest of the build script

install -v "$FILE_FOLDER"/scale-up.desktop /usr/local/share/applications/
install -v "$FILE_FOLDER"/scale-down.desktop /usr/local/share/applications/

install -v -m 755 "$FILE_FOLDER"/scale-up /usr/local/bin/
install -v -m 755 "$FILE_FOLDER"/scale-down /usr/local/bin/

install -v -m 755 "$FILE_FOLDER"/twofing-detect.sh /usr/local/sbin/twofing-detect

# replace budgie-wm with openbox
sed -i 's/org.buddiesofbudgie.BudgieWm;//' /usr/share/gnome-session/sessions/org.buddiesofbudgie.BudgieDesktop.session
