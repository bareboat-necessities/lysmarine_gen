#!/bin/bash -e

install -m 664 -v "$FILE_FOLDER"/can0 "/etc/network/interfaces.d/can0"
install -m 664 -v "$FILE_FOLDER"/can1 "/etc/network/interfaces.d/can1"
