#!/bin/bash -e

# TODO:
exit 0

# Network manager
apt-get install -y -q network-manager make avahi-daemon bridge-utils wakeonlan #createap

# Resolve lysmarine.local
install -v "$FILE_FOLDER"/hostname "/etc/"
cat "$FILE_FOLDER"/hosts >> /etc/hosts
sed -i '/raspberrypi/d' /etc/hosts

# Access Point management
install -m0600 -v "$FILE_FOLDER"/lysmarine-hotspot.nmconnection "/etc/NetworkManager/system-connections/"
systemctl disable dnsmasq || true

##  NetworkManager provide its own wpa_supplicant, stop the others to avoid conflicts.
if service --status-all | grep -Fq 'dhcpcd'; then
	systemctl disable dhcpcd.service
fi
systemctl disable wpa_supplicant.service
systemctl disable hostapd.service || true

## Disable some useless networking services
systemctl disable NetworkManager-wait-online.service # if we do not boot remote user over the network this is not needed
systemctl disable ModemManager.service # for 2G/3G/4G
systemctl disable pppd-dns.service || true # For dial-up Internet LOL

install -v -m 0644 "$FILE_FOLDER"/wifi_powersave@.service "/etc/systemd/system/"
systemctl disable wifi_powersave@on.service
systemctl mask wifi_powersave@on.service
systemctl enable wifi_powersave@off.service

sed -i 's/\[main\]$/[main]\ndns=dnsmasq/' /etc/NetworkManager/NetworkManager.conf

echo 'ap_scan=1' >> /etc/wpa_supplicant/wpa_supplicant.conf
echo 'country=US' >> /etc/wpa_supplicant/wpa_supplicant.conf
echo 'options cfg80211 ieee80211_regdom=US' > /etc/modprobe.d/cfg80211.conf
