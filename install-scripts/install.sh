#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/lib/common.sh"

echo "Install script for BBN OS (LITE) :)"

require_root
require_arch
require_trixie

echo "Architecture: $LMARCH"
echo "Base OS codename: $BBN_OS_CODENAME"

## This makes less noise in cross-build environment.
export LANG="en_US.UTF-8"
export LANGUAGE=en_US:en
export LC_NUMERIC="C"
export LC_CTYPE="C"
export LC_MESSAGES="C"
export LC_ALL="C"

## If no build stage provided, build all stages.
if [ "$#" -gt "0" ]; then
  argumentList="$@"
else
  argumentList="*.*"
fi

set -f
for argument in $argumentList; do # access each element of array
  stage=$(echo "$argument" | cut -d '.' -f 1)
  script=$(echo "$argument" | cut -s -d '.' -f 2)

  if [ ! "$script" ]; then
    script="*"
  fi

  set +f
  for scriptLocation in "$SCRIPT_DIR"/$stage*/$script*.sh; do
    if [ -f "$scriptLocation" ]; then
      echo "From request $argument "
      echo "Running stage $stage -> $script ( $scriptLocation )"
      export FILE_FOLDER=${scriptLocation%/*}/files/
      chmod +x "$scriptLocation"
      $scriptLocation
      [[ ${PIPESTATUS[0]} -ne 0 ]] && exit 255
    fi
  done
done

echo "Done installing script for BBN OS $BBN_KIND :)"
