#!/bin/bash -e

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

# See: https://getpat.io/

apt-get -y install libax25 ax25-tools tmd710-tncsetup

wget https://dl.cloudsmith.io/public/bbn-projects/bbn-deb-repo/deb/debian/pool/trixie/main/p/pa/pat_0.15.1/pat_0.15.1_arm64.deb
dpkg -i pat_0.15.1_arm64.deb && rm pat_0.15.1_arm64.deb

# See: https://www.cantab.net/users/john.wiseman/Documents/ARDOPC.html
wget -O ardopc http://www.cantab.net/users/john.wiseman/Downloads/Beta/piardopc
install ardopc /usr/local/bin && rm ardopc
if [ "$(grep 'pcm\.ARDOP' /home/user/.asoundrc | wc -l)" -lt "1" ]; then
  echo 'pcm.ARDOP {type rate slave {pcm "hw:CARD=CODEC,DEV=0" rate 48000}}' >> /home/user/.asoundrc
fi
/home/user/add-ons/winlink-pat-install.sh


# This is something else: https://bitbucket.org/VK2ETA/
my_dir="$(pwd)"
JPSKMAIL_HOME=/home/user
mkdir -p ${JPSKMAIL_HOME}/jpskmail && cd ${JPSKMAIL_HOME}/jpskmail
wget https://github.com/bareboat-necessities/javapskmail-VK2ETA/raw/main/JavaPskmailServer-0.9.4.a24-20210815.zip && \
  unzip JavaPskmailServer-0.9.4.a24-20210815.zip
chmod 644 ./*
chmod 755 ./lib
rm JavaPskmailServer-0.9.4.a24-20210815.zip
cd "$my_dir"

bash -c 'cat << EOF > /usr/local/share/applications/jpskmail.desktop
[Desktop Entry]
Type=Application
Name=jpskmail
GenericName=jpskmail for WinLink
Comment=jpskmail for WinLink
Exec=sh -c "cd /home/user/jpskmail; java -jar JavaPskmailServer-0.9.4.a24-20210815.jar"
Terminal=false
Icon=radio
Categories=Radio
Keywords=HamRadio;Radio
EOF'

## Reduce excessive logging
#sed '1 i :msg, contains, "Error reading from modem (Exception)" stop' -i /etc/rsyslog.conf
