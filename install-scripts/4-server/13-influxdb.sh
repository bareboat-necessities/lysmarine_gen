#!/bin/bash -e

#TODO
exit 0

apt-get clean

apt-get -y -q install influxdb #chronograf kapacitor telegraf

systemctl unmask influxdb
systemctl disable influxdb

#systemctl disable chronograf
#systemctl disable kapacitor
#systemctl disable telegraf
