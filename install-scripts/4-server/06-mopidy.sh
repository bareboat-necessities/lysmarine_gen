#!/bin/bash -e

# TODO:
exit 0

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

# Install Mopidy and all dependencies:
#apt-get -y install mopidy mopidy-mpd mopidy-spotify mopidy-tunein libspotify-dev xdotool

apt-get -y --no-install-recommends install mopidy mopidy-mpd mopidy-tunein xdotool gstreamer1.0-plugins-bad

#if [ $LMARCH == 'armhf' ]; then
#  apt-get -y install mopidy-spotify libspotify-dev
#fi

adduser mopidy video
adduser mopidy audio

# Install some needed packages
pip3 install install systems

#pip3 install --pre Mopidy-YouTube

pip3 install Mopidy-YTMusic Mopidy-Pandora Mopidy-SoundCloud

# Install Mopidy Web Clients:
pip3 install Mopidy-MusicBox-Webclient Mopidy-Iris

sh -c 'echo "mopidy ALL=NOPASSWD: /usr/local/lib/python3.11/dist-packages/mopidy_iris/system.sh" >> /etc/sudoers'

pip3 install yt-dlp
pip3 install --upgrade requests
pip3 install --upgrade https://github.com/natumbri/mopidy-youtube/archive/develop.zip

pip3 install "ytmusicapi==0.22.0"

install -m 644 "$FILE_FOLDER"/.asoundrc "/home/user/"
install -m 644 "$FILE_FOLDER"/mopidy.conf "/etc/mopidy/"
install -m 755 -d -o mopidy -g audio "/var/lib/mopidy/m3u"
install -m 644 -o mopidy -g audio "$FILE_FOLDER"/BBN-Playlist.m3u8 "/var/lib/mopidy/m3u/"
install -m 644 "$FILE_FOLDER"/mopidy.service "/usr/lib/systemd/system/"

install -m 755 "$FILE_FOLDER"/mopidy-restart "/usr/local/sbin/mopidy-restart"

echo "" >>/etc/sudoers
echo 'user ALL=(ALL) NOPASSWD: /usr/local/sbin/mopidy-restart' >>/etc/sudoers

# Enable mopidy service
systemctl enable mopidy
