#!/bin/bash -e

install -m 644 -o signalk -g signalk "$FILE_FOLDER"/settings.json "/home/signalk/.signalk/settings.json"
