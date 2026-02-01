#!/bin/bash -e

usermod -a -G render user

apt-get install -y -q libglew2.2 gettext libwxsvg3 libtinyxml2.6.2v5 libunarr1 libwxgtk-webview3.2-1 wx3.2-i18n \
  libjs-mathjax libjs-highlight.js libcxx-serial1 fonts-mathjax

install -o 1000 -g 1000 -d "/home/user/.opencpn"
install -o 1000 -g 1000 -d "/home/user/.opencpn/plugins"
install -o 1000 -g 1000 -d "/home/user/.opencpn/plugins/weather_routing"
install -o 1000 -g 1000 -d "/home/user/.opencpn/plugins/weather_routing/data"
install -o 1000 -g 1000 -v "$FILE_FOLDER"/opencpn.conf "/home/user/.opencpn/"
install -o 1000 -g 1000 -v "$FILE_FOLDER"/opencpn.conf "/home/user/.opencpn/opencpn.conf-bbn"
install -o 1000 -g 1000 -v "$FILE_FOLDER"/opencpn.conf-highres-bbn "/home/user/.opencpn/opencpn.conf-highres-bbn"

# Polar Diagrams

BK_DIR="$(pwd)"

mkdir /home/user/Polars && cd /home/user/Polars

wget https://www.seapilot.com/wp-content/uploads/2018/05/All_polar_files.zip
unzip All_polar_files.zip
chown user:user ./*
chmod 664 ./*
rm All_polar_files.zip

cd "$BK_DIR"

mkdir tmp-o-bundle-"$LMARCH" || exit 2
cd tmp-o-bundle-"$LMARCH"

if [ "$BBN_KIND" == "LITE" ] ; then
  wget -O opencpn-plugins-bundle-"$LMARCH".tar.gz https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/opencpn-plugins-bundle-o_5_10_x-trixie-lite-2-"$LMARCH".tar.gz
else
  wget -O opencpn-plugins-bundle-"$LMARCH".tar.gz https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/opencpn-plugins-bundle-o_5_10_x-trixie-full-2-"$LMARCH".tar.gz
fi
gzip -cd opencpn-plugins-bundle-"$LMARCH".tar.gz | tar xvf -

mkdir -p /home/user/.local/lib /home/user/.local/bin /home/user/.local/share /home/user/.local/doc /home/user/.local/include
cp -r -p lib/* /home/user/.local/lib/
cp -r -p bin/* /home/user/.local/bin/ || true
cp -r -p share/* /home/user/.local/share/
cp -r -p doc/* /home/user/.local/doc/ || true
cp -r -p include/* /home/user/.local/include/ || true

chown -R user:user /home/user/.local

cd ..
rm -rf tmp-o-bundle-"$LMARCH"

if [ -f /home/user/.local/lib/opencpn/libPolar_pi.so ]; then
  mv /home/user/.local/lib/opencpn/libPolar_pi.so /usr/lib/opencpn/libpolar_pi.so
fi

if [ -f /home/user/.local/lib/opencpn/liblogbookkonni_pi.so ]; then
  rm -f /home/user/.local/lib/opencpn/libLogbookKonni_pi.so
fi

mv /home/user/.local/share/opencpn/plugins/tactics_pi/data/Tactics.svg /home/user/.local/share/opencpn/plugins/tactics_pi/data/tactics.svg
mv /home/user/.local/share/opencpn/plugins/tactics_pi/data/Tactics_rollover.svg /home/user/.local/share/opencpn/plugins/tactics_pi/data/tactics_rollover.svg
mv /home/user/.local/share/opencpn/plugins/tactics_pi/data/Tactics_toggled.svg /home/user/.local/share/opencpn/plugins/tactics_pi/data/tactics_toggled.svg
#mv /home/user/.local/share/opencpn/plugins/CanadianTides_pi/data/canadiantides_panel_icon.png /home/user/.local/share/opencpn/plugins/CanadianTides_pi/data/CanadianTides_panel_icon.png

#wget --no-check-certificate https://download.tuxfamily.org/xinutop/rastow/rastow-0.4.tgz
wget --no-check-certificate https://absinthe.tuxfamily.org/xinutop/rastow/rastow-0.4.tgz
gzip -cd rastow-0.4.tgz | tar xvf -
mv rastow.sh /usr/local/bin
rm rastow-0.4.tgz
#wget --no-check-certificate https://download.tuxfamily.org/xinutop/rastow/readme.txt
wget --no-check-certificate https://absinthe.tuxfamily.org/xinutop/rastow/readme.txt
mkdir /usr/local/share/rastow
mv readme.txt /usr/local/share/rastow/

# TODO: temp fix
AGENT="Debian APT-HTTP/1.3 (2.6.1)"
xargs -n 1 -P 3 wget --user-agent="$AGENT" -q << EOF
https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/opencpn_5.10.2+dfsg-1.bpo12+1_arm64.deb
https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/opencpn-data_5.10.2+dfsg-1.bpo12+1_all.deb
https://raw.githubusercontent.com/OpenCPN/plugins/master/ocpn-plugins.xml
EOF
mv -f ocpn-plugins.xml /home/user/.opencpn/
chown user:user /home/user/.opencpn/ocpn-plugins.xml
dpkg -i opencpn*5.10.*.deb
rm opencpn*5.10.*.deb
rm /etc/apt/sources.list.d/opencpn.list

# ImgKap https://github.com/nohal
apt-get -y install libfreeimage-dev
git clone --depth=1 https://github.com/nohal/imgkap
cd imgkap
make -j 5
make install
cd ..
rm -rf imgkap

# for OpenCPN
#ln -s /usr/share/opencpn/tcdata/harmonics-dwf-20220109/harmonics-dwf-20220109-free.tcd /usr/share/opencpn/tcdata/harmonics-dwf-20210110-free.tcd

install -v "$FILE_FOLDER"/opencpn.desktop "/usr/share/applications/"
install -o 1000 -g 1000 -m 644 -v "$FILE_FOLDER"/opencpn.desktop "/home/user/.config/autostart/"

wget https://raw.githubusercontent.com/OpenCPN/plugins/master/ocpn-plugins.xml
mv -f ocpn-plugins.xml /home/user/.opencpn/
chown user:user /home/user/.opencpn/ocpn-plugins.xml

apt-mark hold opencpn

# fixes for touchscreen
# we use gtk3 update with the fix from https://www.free-x.de/deb4op trixie-preview
# (Note: disabled this fix as it broke other programs Stellarium, APMPlanner2, swipe gesture on BBNLauncher
# It worked for OpenCPN and make zoom more sensitive (same might be achieved with twofing to change zoom step in
# default profile)
#cat << EOF > /etc/apt/sources.list.d/trixie-preview.list
#deb https://www.free-x.de/deb4op trixie-preview main
#EOF
#wget -O - https://www.free-x.de/deb4op/oss.boating.gpg.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/oss.boating.gpg

