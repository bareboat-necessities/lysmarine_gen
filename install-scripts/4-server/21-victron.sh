#!/bin/bash -e

# see https://github.com/victronenergy/venus-html5-app
pushd /usr/share/
  wget https://github.com/bareboat-necessities/lysmarine_gen/releases/download/vTest/venus-html5-app-build.tar.gz
  mkdir venus-app
  cd venus-app
  gzip -cd ../venus-html5-app-build.tar.gz | tar xvf -
  rm ../venus-html5-app-build.tar.gz
popd

npm install -g serve

# to start:
#
# cd /usr/share/venus-app
# serve -l 8000
#
# And then open the app in the browser at http://localhost:8000/app
#
# This will start the webpack dev server, which will recompile the app on code changes and hot reload the UI.
#
# You can change the host and port (although the default 9001 is usually correct) query parameters to point
# to your Venus device:
#
# http://localhost:8000/app?host=<VENUS_DEVICE_IP>&port=9001
#
# This way you can run the local app against venus device data if the venus device
# is on the same network as your computer.

install -v -m 0644 "$FILE_FOLDER"/victron.service "/etc/systemd/system/"

systemctl enable victron.service
