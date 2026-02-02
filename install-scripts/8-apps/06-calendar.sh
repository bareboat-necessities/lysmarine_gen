#!/bin/bash -e

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

apt-get -y -q install gnome-calendar gnome-todo # libcanberra-gtk-module
