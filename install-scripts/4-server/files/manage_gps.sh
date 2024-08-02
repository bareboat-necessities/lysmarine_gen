#!/bin/sh
chmod a+r /dev/ttyLYS_gps_"$1"
if [[ $2 == "remove" ]] ; then
  logger "The USB device /dev/ttyLYS_gps_$1 has been disconnected"
  if [[ $1 == "0" ]] ; then
    /usr/bin/su -c '/usr/bin/gpsdctl remove /dev/ttyLYS_gps_0'
  else
    /usr/bin/su -c '/usr/bin/systemctl stop lysgpsd@'"$1"'.service'
  fi
else
  if [[ $1 == "0" ]] ; then
    /usr/bin/su -c '/usr/bin/systemctl restart gpsd'
    logger "This USB device is known as GPS and will be connected to gpsd on port 2947 /dev/ttyLYS_gps_$1"
    /usr/bin/su -c 'GPSD_OPTIONS="-p"; export GPSD_OPTIONS; /usr/bin/gpsdctl add /dev/ttyLYS_gps_0'
  else
    /usr/bin/su -c '/usr/bin/systemctl restart lysgpsd@'"$1"'.service'
    /usr/bin/su -c '/usr/bin/systemctl is-enabled signalk && systemctl restart signalk'
    logger "This USB device is known as GPS and will be connected to gpsd on port 2947$1 /dev/ttyLYS_gps_$1"
  fi
fi
