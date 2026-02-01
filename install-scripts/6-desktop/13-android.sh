#!/bin/bash -e

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

apt-get install -y ffmpeg libsdl2-2.0-0 adb \
  pkg-config meson ninja-build # TODO: scrcpy


apt-get install -y libsdl2-dev libavcodec-dev libavdevice-dev libavformat-dev libusb-1.0-0-dev
git clone --depth=1 https://github.com/Genymobile/scrcpy
cd scrcpy
sed -i -e 's/sudo//g' install_release.sh
./install_release.sh
cd ..
rm -rf scrcpy


git clone --depth=1 https://github.com/M0Rf30/android-udev-rules.git
cd android-udev-rules

# Copy rules file
cp -v 51-android.rules /etc/udev/rules.d/51-android.rules

# Change file permissions
chmod a+r /etc/udev/rules.d/51-android.rules

# Add the adbusers group if it's doesn't already exist
cp android-udev.conf /usr/lib/sysusers.d/
systemd-sysusers

# Add your user to the adbusers group
gpasswd -a user adbusers

cd ..
rm -rf android-udev-rules

install -v -m 0644 "$FILE_FOLDER"/scrcpy.desktop "/usr/local/share/applications/"

############################

# TODO: disabled
#apt-get install -y autoadb  # v4l2loopback-dkms

wget https://github.com/bareboat-necessities/autoadb/releases/download/1.0.0.0-trixie/autoadb_1.0.0.0_arm64.deb
dpkg -i autoadb_1.0.0.0_arm64.deb
rm autoadb_1.0.0.0_arm64.deb
