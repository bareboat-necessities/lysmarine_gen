#!/usr/bin/env bash

echo "Publishing"

set -x

EXT=$1
REPO=$2
DISTRO=$3

pwd
ls

for pkg_file in cross-build-release/release/*/*."$EXT"; do
  zipName=$(basename "$pkg_file")
  zipDir=$(dirname "$pkg_file")
  mkdir ./tmp
  chmod 755 ./tmp
  cd "$zipDir" || exit 255
  export XZ_DEFAULTS='--threads=5'
  if [[ "${zipName}" =~ "full" ]]; then
    xz -z -c -v -8 --threads=4 --memory=90% "${zipName}" > ../../../tmp/"${zipName}".xz
  else
    xz -z -c -v -8 --threads=4 --memory=90% "${zipName}" > ../../../tmp/"${zipName}".xz
  fi
  cd ../../..
  cloudsmith push raw "$REPO" ./tmp/"${zipName}".xz --summary "BBN OS built by CircleCi on $(date)" --description "BBN OS build"
  RESULT=$?
  if [ $RESULT -eq 144 ]; then
    echo "skipping already deployed $pkg_file"
  fi
done
