#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

export NEEDRESTART_MODE=a

# systemctl will fail inside containers/chroots without systemd as PID 1
has_systemd() { command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; }
systemctl_safe() {
  if has_systemd; then
    systemctl "$@"
  else
    log "[skip] systemctl $* (systemd not active)"
    return 0
  fi
}

# Ensure a group exists
ensure_group() {
  local g="$1"
  if ! getent group "$g" >/dev/null 2>&1; then
    groupadd --system "$g" 2>/dev/null || groupadd "$g"
  fi
}

# Ensure a system user exists
ensure_system_user() {
  local u="$1"
  if ! id -u "$u" >/dev/null 2>&1; then
    adduser --home "/home/$u" --gecos "" --system --disabled-password --disabled-login "$u"
  fi
}

# Add user to group if group exists
add_to_group_if_exists() {
  local u="$1" g="$2"
  if getent group "$g" >/dev/null 2>&1; then
    usermod -a -G "$g" "$u" || true
  else
    log "[skip] group $g missing; not adding $u"
  fi
}

# Install Node.js 22 from NodeSource
log "Configuring NodeSource Node.js 22..."
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

log "Updating apt + installing base deps..."
apt-get update -q
apt-get install -y -q --no-install-recommends \
  ca-certificates curl wget \
  git jq \
  nodejs node-nan \
  python3 python3-dev python3-pip python3-setuptools \
  make g++ pkg-config \
  libnss-mdns avahi-utils \
  libsqlite3-0 libsqlite3-dev \
  i2c-tools \
  libzmq3-dev libkrb5-dev libavahi-compat-libdnssd-dev

log "Installing modern node-gyp + tooling..."
npm cache clean --force || true
npm install -g npm patch-package typescript node-gyp@latest

NODE_GYP_JS="$(npm root -g)/node-gyp/bin/node-gyp.js"
if [ ! -f "$NODE_GYP_JS" ]; then
  log "ERROR: global node-gyp not found at $NODE_GYP_JS"
  npm root -g || true
  ls -la "$(npm root -g)/node-gyp/bin" || true
  exit 1
fi
export npm_config_node_gyp="$NODE_GYP_JS"
log "Using node-gyp: $npm_config_node_gyp ($(node-gyp --version || true))"
log "Node: $(node -v), npm: $(npm -v), python: $(python3 -V)"

# Create user/group
ensure_group signalk
ensure_system_user signalk

# Add signalk user to hardware-ish groups if they exist in this rootfs
for g in tty i2c spi gpio dialout plugdev lirc; do
  add_to_group_if_exists signalk "$g"
done

# Charts group and directory
if ! getent group charts >/dev/null 2>&1; then
  groupadd charts
fi
add_to_group_if_exists signalk charts
add_to_group_if_exists user charts || true
add_to_group_if_exists root charts || true

install -v -d -m 6775 -o signalk -g charts /srv/charts

# Link charts for user convenience (only if /home/user exists)
if [ -d /home/user ] && [ ! -e /home/user/charts ]; then
  su user -c "ln -s /srv/charts /home/user/charts" || true
fi

# Optional deps that may not exist everywhere; install if available
install_if_available() {
  local pkg="$1"
  if apt-cache show "$pkg" >/dev/null 2>&1; then
    apt-get install -y -q "$pkg"
  else
    log "[skip] apt package not available: $pkg"
  fi
}

# These may or may not exist in your trixie repo set:
install_if_available libi2c-dev
install_if_available node-abstract-leveldown

# Prepare Signalk home
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/plugin-config-data"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/node_modules"

# Copy config files
for f in \
  set-system-time.json \
  sk-to-nmea0183.json \
  signalk-path-filter.json \
  derived-data.json \
  charts.json \
  anchoralarm.json \
  autopilot.json \
  signalk-navtex-plugin.json \
  simple-notifications.json \
  freeboard-sk-helper.json \
  freeboard-sk.json \
  resources-provider.json \
  xdrParser-plugin.json
do
  install -m 644 -o signalk -g signalk "$FILE_FOLDER/$f" "/home/signalk/.signalk/plugin-config-data/"
done

install -m 644 -o signalk -g signalk "$FILE_FOLDER/defaults.json" "/home/signalk/.signalk/defaults.json"
install -m 644 -o signalk -g signalk "$FILE_FOLDER/package.json"  "/home/signalk/.signalk/package.json"
install -m 644 -o signalk -g signalk "$FILE_FOLDER/settings.json" "/home/signalk/.signalk/settings.json"
install -m 755 -o signalk -g signalk "$FILE_FOLDER/signalk-server" "/home/signalk/.signalk/signalk-server"
install -m 755 "$FILE_FOLDER/signalk-restart" "/usr/local/sbin/signalk-restart"

# Icons for desktop user (guard if /home/user exists)
if [ -d /home/user ]; then
  install -d -o signalk -g signalk "/home/user/.local/share/icons/"
  # Use user:group ids only if they exist; otherwise fall back to SignalK ownership
  if id -u user >/dev/null 2>&1; then
    install -m 644 -o user -g user "$FILE_FOLDER/icons/signalk.png" "/home/user/.local/share/icons/" || \
    install -m 644 -o signalk -g signalk "$FILE_FOLDER/icons/signalk.png" "/home/user/.local/share/icons/"
  else
    install -m 644 -o signalk -g signalk "$FILE_FOLDER/icons/signalk.png" "/home/user/.local/share/icons/"
  fi
fi

# systemd service (guarded enable/disable later)
install -d /etc/systemd/system
install -m 644 "$FILE_FOLDER/signalk.service" "/etc/systemd/system/signalk.service"

# Install Signal K server globally
log "Installing SignalK-server globally..."
npm cache clean --force || true
# --unsafe-perm is often needed for native addons/scripts when running as root during image build
npm install -g --unsafe-perm --production signalk-server

# Helper to run npm as SignalK with correct env (node-gyp override + flags)
run_as_signalk() {
  local cmd="$1"
  su signalk --shell=/bin/bash -c "
    set -euo pipefail
    export MAKEFLAGS='-j 8'
    export NODE_ENV=production
    export npm_config_node_gyp='$npm_config_node_gyp'
    export TERM='${TERM}'
    $cmd
  "
}

# Install plugins in /home/signalk/.signalk
pushd /home/signalk/.signalk >/dev/null

log "Installing Signal K plugins (LITE) via npm..."
run_as_signalk "
  npm install --unsafe-perm --loglevel error --omit=dev \
    @signalk/resources-provider \
    @signalk/charts-plugin \
    @signalk/course-provider \
    signalk-raspberry-pi-bme280 \
    signalk-raspberry-pi-bmp180 \
    signalk-raspberry-pi-ina219 \
    signalk-raspberry-pi-1wire \
    signalk-venus-plugin \
    signalk-mqtt-gw \
    signalk-derived-data \
    signalk-anchoralarm-plugin \
    signalk-alarm-silencer \
    signalk-simple-notifications \
    signalk-to-nmea2000 \
    signalk-sonoff-ewelink \
    signalk-shelly \
    @mxtommy/kip \
    nmea0183-to-nmea0183 \
    xdr-parser-plugin \
    signalk-path-filter \
    signalk-datetime \
    @meri-imperiumi/signalk-autostate
"

popd >/dev/null

# Patches / fixes
sed -i "s#sudo ##g" /home/signalk/.signalk/node_modules/signalk-raspberry-pi-monitoring/index.js || true
sed -i "s#/opt/vc/bin/##g" /home/signalk/.signalk/node_modules/signalk-raspberry-pi-monitoring/index.js || true
sed -i 's#@signalk/server-admin-ui#admin#' "$(find /usr/lib/node_modules/signalk-server -name tokensecurity.js 2>/dev/null)" || true

# see https://github.com/SignalK/signalk-server/pull/1455/
sed -i 's/\(filter(.*\]\)/"".join(\1)/'  "$(find /usr/lib/node_modules/signalk-server -name pigpio-seatalk.js 2>/dev/null)" || true

# sudoers tweaks
{
  echo "signalk ALL=(ALL) NOPASSWD: /bin/date";
  echo "signalk ALL=(ALL) NOPASSWD: /usr/bin/date";
  echo "signalk ALL=(ALL) NOPASSWD: /bin/timedatectl";
  echo "signalk ALL=(ALL) NOPASSWD: /usr/bin/timedatectl";
} >> /etc/sudoers

echo "" >> /etc/sudoers
echo "user ALL=(ALL) NOPASSWD: /usr/local/sbin/signalk-restart" >> /etc/sudoers

# Seatalk: disable pigpio if possible
systemctl_safe disable pigpiod || true

# Seatalk helper
wget -q -O /usr/local/sbin/STALK_read.py \
  https://raw.githubusercontent.com/MatsA/seatalk1-to-NMEA0183/master/STALK_read.py
chmod 0755 /usr/local/sbin/STALK_read.py || true

# Enable SignalK service (guarded)
systemctl_safe enable signalk || true

install -d /usr/local/share/applications

# Clean caches
rm -rf /home/signalk/.cache /home/signalk/.npm /home/signalk/.node-* || true
npm cache clean --force || true
