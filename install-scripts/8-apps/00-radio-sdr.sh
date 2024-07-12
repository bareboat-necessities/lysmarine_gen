#!/bin/bash -e

apt-get clean

install -d -m 755 "/usr/local/share/noaa-apt"
install -d -m 755 "/usr/local/share/noaa-apt/res"
install -d -m 755 "/usr/local/share/noaa-apt/res/shapefiles"
install -v "$FILE_FOLDER"/noaa-apt.desktop -o 1000 -g 1000 "/home/user/.local/share/applications/ar.com.mbernardi.noaa-apt.desktop"
wget -q -O - https://github.com/martinber/noaa-apt/raw/master/res/icon.png > "/usr/local/share/noaa-apt/res/icon.png"
wget -q -O - https://github.com/martinber/noaa-apt/raw/master/res/shapefiles/countries.shp > "/usr/local/share/noaa-apt/res/shapefiles/countries.shp"
wget -q -O - https://github.com/martinber/noaa-apt/raw/master/res/shapefiles/lakes.shp > "/usr/local/share/noaa-apt/res/shapefiles/lakes.shp"
wget -q -O - https://github.com/martinber/noaa-apt/raw/master/res/shapefiles/states.shp > "/usr/local/share/noaa-apt/res/shapefiles/states.shp"

if [ "$LMARCH" == 'arm64' ]; then
  wget https://github.com/bareboat-necessities/noaa-apt/releases/download/v1.4.1-bookworm/noaa-apt_1.4.1-2_arm64.deb -O noaa-apt.deb
fi
dpkg -i noaa-apt.deb && rm -f noaa-apt.deb
rm -f /usr/local/share/noaa-apt/test/test*.wav


#################################

apt-get -y install libaudiofile-dev
mdir=$(pwd)
cd /usr/local/share
git clone --depth=1 https://github.com/cropinghigh/inmarsatc
git clone --depth=1 https://github.com/cropinghigh/stdcdec
rm -rf inmarsatc/.git
rm -rf stdcdec/.git
cd "$mdir"

#################################

install -v -m 0644 "$FILE_FOLDER"/50-rtl-sdr.rules "/etc/udev/rules.d/"
install -v -m 0644 "$FILE_FOLDER"/52-airspy.rules "/etc/udev/rules.d/"
install -v -m 0644 "$FILE_FOLDER"/52-airspyhf.rules "/etc/udev/rules.d/"
install -v -m 0644 "$FILE_FOLDER"/53-hackrf.rules "/etc/udev/rules.d/"
install -v -m 0644 "$FILE_FOLDER"/66-mirics.rules "/etc/udev/rules.d/"
install -v -m 0644 "$FILE_FOLDER"/88-nuand-bladerf1.rules "/etc/udev/rules.d/"
install -v -m 0644 "$FILE_FOLDER"/88-nuand-bladerf2.rules "/etc/udev/rules.d/"
install -v -m 0644 "$FILE_FOLDER"/88-nuand-bootloader.rules "/etc/udev/rules.d/"
#install -v -m 0644 "$FILE_FOLDER"/99-com.rules "/etc/udev/rules.d/"
install -v -m 0644 "$FILE_FOLDER"/99-direwolf-cmedia.rules "/etc/udev/rules.d/"
install -v -m 0644 "$FILE_FOLDER"/99-thumbdv.rules "/etc/udev/rules.d/"

#################################

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

#################################

apt-get -y -q --no-install-recommends --no-install-suggests install \
  cubicsdr                              \
  soapysdr-module-all                   \
  cutesdr                               \
  fldigi                                \
  gpredict                              \
  previsat                              \
  rtl-sdr                               \
  librtlsdr-dev                         \
  dos2unix                              \
  gqrx-sdr                              \
  soapysdr-tools                        \
  hackrf                                \
  osmo-sdr                              \
  airspy                                \
  sox                                   \
  soundmodem                            \
  morse2ascii                           \
  wmctrl                                \
  rtl-sdr                               \
  librxtx-java                          \
  libhamlib-utils                       \
  python3-libxml2                       \
  python3-serial                        \
  libtool                               \
  libfftw3-dev

#  direwolf                              \
#  w-scan                                \
#  multimon-ng                           \
#  aprx                                  \
#  dvb-tools                             \
#  dvb-apps                              \
#  dtv-scan-tables                       \
#  chirp                                 \
#  gnuradio                              \
#  gnss-sdr                              \
#  gnuais                                \
#  gnuaisgui                             \

install -d -m 755 -o 1000 -g 1000 "/home/user/.config/gqrx/"
install -v "$FILE_FOLDER"/gqrx-default.conf -o 1000 -g 1000 "/home/user/.config/gqrx/default.conf"
install -v "$FILE_FOLDER"/gqrx-bookmarks.csv -o 1000 -g 1000 "/home/user/.config/gqrx/bookmarks.csv"

systemctl disable soundmodem

#systemctl disable direwolf
#install -v "$FILE_FOLDER"/direwolf.conf -o 1000 -g 1000 "/home/user/"

#systemctl disable aprx

install -v "$FILE_FOLDER"/jnx.desktop /usr/local/share/applications/
install -v "$FILE_FOLDER"/jwx.desktop /usr/local/share/applications/

install -d -m 755 "/usr/local/share/jnx"
install -d -m 755 "/usr/local/share/jwx"

wget -q -O - https://github.com/bareboat-necessities/jnx-alt/releases/download/v2011.03.25/jnx-2011.03.25-jar-with-dependencies.jar > /usr/local/share/jnx/JNX.jar
#wget -q -O - https://arachnoid.com/JNX/JNX_source.tar.gz > /usr/local/share/jnx/JNX_source.tar.gz

wget -q -O - https://github.com/bareboat-necessities/jwx-alt/releases/download/v2017.11.20/jwx-2017.11.20-jar-with-dependencies.jar > /usr/local/share/jwx/JWX.jar
#wget -q -O - https://arachnoid.com/JWX/resources/JWX_source.tar.bz2 > /usr/local/share/jwx/JWX_source.tar.bz2

apt-get -y -q install fontconfig

#################################

apt-get install -y --no-install-recommends --no-install-suggests \
  cmake libasound-dev libpulse-dev automake autoconf m4

pushd /usr/local/share
  git clone --depth=1 https://github.com/bareboat-necessities/aisdecoder
  cd aisdecoder
  rm -rf .git/
  mkdir build && cd build
  # Moving to first-run due to this bug: https://gitlab.kitware.com/cmake/cmake/-/issues/20568
  if [ "$LMARCH" == 'arm64' ]; then
    cmake ../ -DCMAKE_BUILD_TYPE=RELEASE
    make -j 4
    cp aisdecoder /usr/local/bin/
    make clean
  fi
  cd ../..
popd

install -d '/usr/local/share/hf-propagation'
install -v -m 0644 "$FILE_FOLDER"/propagation.html "/usr/local/share/hf-propagation/"
install -v "$FILE_FOLDER"/propagation.desktop "/usr/local/share/applications/"


git clone --depth=1 https://github.com/globecen/rtl-ais
cd rtl-ais
make -j 4
cp rtl_ais /usr/bin/
cd ..
rm -rf rtl-ais

git clone --depth=1 https://github.com/steve-m/kalibrate-rtl
cd kalibrate-rtl/
./bootstrap && CXXFLAGS='-W -Wall -O3' ./configure && make -j 4
cp src/kal /usr/local/bin/
cd ..
rm -rf kalibrate-rtl/


######################################################################################################
## YAAC https://www.ka2ddo.org/ka2ddo/YAAC.html
#
#MY_DIR_OLD=$(pwd)
#cd /home/user
#
#wget https://www.ka2ddo.org/ka2ddo/YAAC.zip
#mkdir YAAC && cd YAAC
#unzip ../YAAC.zip
#rm -f ../YAAC.zip
#
#bash -c 'cat << EOF > /usr/local/share/applications/YAAC.desktop
#[Desktop Entry]
#Type=Application
#Name=YAAC
#GenericName=YAAC
#Comment=YAAC
#Exec=sh -c "cd /home/user/YAAC; java -jar YAAC.jar"
#Terminal=false
#Icon=radio
#Categories=HamRadio;Radio;Weather
#Keywords=HamRadio;Radio;Weather
#EOF'
#
#cd "$MY_DIR_OLD"
#rm -rf ~/.wget*


#install -v "$FILE_FOLDER"/gnuaisgui.desktop /usr/local/share/applications/
install -v "$FILE_FOLDER"/previsat.desktop /usr/local/share/applications/

if [ "$LMARCH" == 'arm64' ]; then
  wget https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/hamfax_0.8.1.1-1_arm64.deb
  dpkg -i hamfax_0.8.1.1-1_arm64.deb
  rm hamfax_0.8.1.1-1_arm64.deb
fi

install -v "$FILE_FOLDER"/hamfax.desktop -o 1000 -g 1000 "/home/user/.local/share/applications/hamfax.desktop"

if [ 'z' == 'a' ]; then
  pip3 install pyrtlsdr wheel
  # quisk
  apt-get -y -q --no-install-recommends --no-install-suggests install python3-wxgtk4.0 \
      libfftw3-dev                       \
      libasound2-dev                     \
      portaudio19-dev                    \
      libpulse-dev                       \
      python3-dev                        \
      libpython3-dev                     \
      python3-usb                        \
      python3-wheel                      \
      python3-setuptools                 \
      python3-pip
  pip3 install --upgrade quisk
  install -v "$FILE_FOLDER"/quisk.desktop /usr/local/share/applications/
  rm -rf ~/.cache/pip
  # To run quisk
  # python3 -m quisk
fi


apt-get clean





