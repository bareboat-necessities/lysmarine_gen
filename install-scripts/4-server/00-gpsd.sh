#!/bin/bash -e

apt-get install -y -q gpsd gpsd-clients gpsd-tools lsof

ln -s /usr/lib/python3/dist-packages/gps /usr/local/lib/python3.11/dist-packages/

## Automatically start gpsd when a USB gps detected, handle AIS
install -d /etc/udev/rules.d
install -v -m 0644 "$FILE_FOLDER"/90-lys-ais.rules "/etc/udev/rules.d/90-lys-ais.rules"
install -v -m 0644 "$FILE_FOLDER"/90-lys-cp210x.rules "/etc/udev/rules.d/90-lys-cp210x.rules"
install -v -m 0644 "$FILE_FOLDER"/90-lys-ch340.rules "/etc/udev/rules.d/90-lys-ch340.rules"
install -v -m 0644 "$FILE_FOLDER"/90-lys-ftdi.rules "/etc/udev/rules.d/90-lys-ftdi.rules"
install -v -m 0644 "$FILE_FOLDER"/90-lys-shipmodul.rules "/etc/udev/rules.d/90-lys-shipmodul.rules"
install -v -m 0644 "$FILE_FOLDER"/90-lys-gps.rules "/etc/udev/rules.d/90-lys-gps.rules"
install -v -m 0644 "$FILE_FOLDER"/90-lys-prolific.rules "/etc/udev/rules.d/90-lys-prolific.rules"
install -v -m 0644 "$FILE_FOLDER"/70-lys-can.rules "/etc/udev/rules.d/70-lys-can.rules"
install -v -m 0644 "$FILE_FOLDER"/91-pc-navtex.rules "/etc/udev/rules.d/91-pc-navtex.rules"
install -v -m 0644 "$FILE_FOLDER"/99-zzz-com.rules "/etc/udev/rules.d/99-zzz-com.rules"

install -d /usr/local/sbin
install -v -m 0755 "$FILE_FOLDER"/bounce-mux.sh "/usr/local/sbin/bounce-mux"

install -d /usr/local/bin
install -v -m 0755 "$FILE_FOLDER"/manage_ais.sh "/lib/udev/manage_ais.sh"
install -v -m 0755 "$FILE_FOLDER"/manage_cp210x.sh "/lib/udev/manage_cp210x.sh"
install -v -m 0755 "$FILE_FOLDER"/manage_ch340.sh "/lib/udev/manage_ch340.sh"
install -v -m 0755 "$FILE_FOLDER"/manage_ftdi.sh "/lib/udev/manage_ftdi.sh"
install -v -m 0755 "$FILE_FOLDER"/manage_shipmodul.sh "/lib/udev/manage_shipmodul.sh"
install -v -m 0755 "$FILE_FOLDER"/manage_gps.sh "/lib/udev/manage_gps.sh"
install -v -m 0755 "$FILE_FOLDER"/manage_prolific.sh "/lib/udev/manage_prolific.sh"

install -d /etc/systemd/system
install -v -m 0644 "$FILE_FOLDER"/lysgpsd@.service "/etc/systemd/system/lysgpsd@.service"
install -v -m 0644 "$FILE_FOLDER"/gpsd.conf "/etc/default/gpsd"
