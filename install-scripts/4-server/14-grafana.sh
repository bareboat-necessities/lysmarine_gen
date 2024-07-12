#!/bin/bash -e

apt-get clean

apt-get -y -q install grafana

systemctl disable grafana-server

sed -i 's/3000/3080/g' /etc/grafana/grafana.ini
sed -i 's/;http_port/http_port/g' /etc/grafana/grafana.ini

apt-get clean

