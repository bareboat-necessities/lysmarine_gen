#!/bin/bash -e

# TODO:
exit 0

apt-get install -y nodejs libavahi-compat-libdnssd-dev python3-dev libsqlite3-0 g++
npm cache verify
if [ ! id -u www-data >/dev/null 2>&1 ] ; then
	adduser --disabled-login --home /var/www www-data
fi

if [ ! -d /var/www  ] ; then
	mkdir /var/www
	chown www-data:www-data /var/www
fi

install -m 755 -d -o www-data -g www-data "/var/www/bbn-launcher"
install -m 755 -d -o www-data -g www-data "/var/www/bbn-launcher/img"
install -m 755 -d -o www-data -g www-data "/var/www/bbn-launcher/js"
install -m 644 -v -o www-data -g www-data "$FILE_FOLDER"/bbn-launcher/bbn-launcher.js "/var/www/bbn-launcher/"
if [ "$BBN_KIND" == "LITE" ] ; then
  install -m 644 -v -o www-data -g www-data "$FILE_FOLDER"/bbn-launcher/constants-lite.js "/var/www/bbn-launcher/constants.js"
else
  install -m 644 -v -o www-data -g www-data "$FILE_FOLDER"/bbn-launcher/constants.js "/var/www/bbn-launcher/"
fi
install -m 644 -v -o www-data -g www-data "$FILE_FOLDER"/bbn-launcher/js/swiped-events.js "/var/www/bbn-launcher/js"
install -m 755 -v -o www-data -g www-data "$FILE_FOLDER"/bbn-launcher/bbn-launcherd "/usr/local/bin/"

for f in "$FILE_FOLDER"/bbn-launcher/img/*.svg; do
  install -m 644 -v -o www-data -g www-data $f "/var/www/bbn-launcher/img"
done

chown -R www-data:www-data /var/www/bbn-launcher

install -d -o 1000 -g 1000 -m 0755 "/home/user/add-ons"
install -v -o 1000 -g 1000 -m 0755 "$FILE_FOLDER"/hot-fixes-install.sh "/home/user/add-ons/"
