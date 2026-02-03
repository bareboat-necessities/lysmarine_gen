#!/bin/bash -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/../lib/common.sh"

apt-get install -y -q yad ssh-askpass-gnome

install -d '/usr/local/share/applications'

install -m 755 "$FILE_FOLDER"/servicedialog-lite.sh "/usr/local/bin/servicedialog"

install -m 644 "$FILE_FOLDER"/servicedialog.desktop "/usr/local/share/applications/"
