#!/bin/bash -e

# It's a crud implementation. Use with caution.

if [ "$EUID" -ne 0 ] ; then
  echo "Run as root"
  exit 1
fi

if [ $# -eq 0 ] ; then
  echo "Provide a new host name as the first argument"
  exit 2
fi

NEW_HOSTNAME=$(echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^0-9a-z-]*//g')
OLD_HOSTNAME="${HOSTNAME:-CoreMP135}"

if [ -z "$NEW_HOSTNAME" ] ; then
  echo "New host name can't be empty"
  exit 3
fi

echo "renaming from $OLD_HOSTNAME to $NEW_HOSTNAME"

sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hostname
sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts

sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" "/home/pypilot/.pypilot/signalk.conf"

echo "Done. Reboot the system for the changes to take effect."
