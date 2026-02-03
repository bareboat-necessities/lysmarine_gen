#!/bin/bash -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/../lib/common.sh"

usermod -a -G render user

apt-get install -y -q opencpn

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
# we use gtk3 update with the fix from https://www.free-x.de/deb4op trixie-preview
# (Note: disabled this fix as it broke other programs Stellarium, APMPlanner2, swipe gesture on BBNLauncher
# It worked for OpenCPN and make zoom more sensitive (same might be achieved with twofing to change zoom step in
# default profile)
#cat << EOF > /etc/apt/sources.list.d/trixie-preview.list
#deb https://www.free-x.de/deb4op trixie-preview main
#EOF
#wget -O - https://www.free-x.de/deb4op/oss.boating.gpg.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/oss.boating.gpg
