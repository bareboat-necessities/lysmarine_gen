#!/bin/bash
chmod a+r /dev/ttyLYS_cp210x_"$1"
if [[ $2 == "remove" ]] ; then
  logger "The USB device /dev/ttyLYS_cp210x_$1 has been disconnected"
else
  /usr/local/sbin/bounce-mux
  logger "This USB device is known as cp210x and will be linked on /dev/ttyLYS_cp210x_$1"
fi
