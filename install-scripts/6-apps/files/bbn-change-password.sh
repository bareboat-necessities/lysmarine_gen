#!/bin/bash

p1=x
p2=

until [ "$p1" == "$p2" ]
do
  if [ -n "$p2" ]; then
     text="Repeated password is not matching new"
  fi
  data=$(yad --title="Change Password" --borders=80 --text="$text" --form --align=right --field="Current Password":H --field="New Password":H --field="Repeat New Password":H)

  if [ "$?" == 0 ]; then
    doit=true
    cpwd=$(echo "$data" | cut -d'|' -f1)
    p1=$(echo "$data" | cut -d'|' -f2)
    p2=$(echo "$data" | cut -d'|' -f3)
  else
    exit 1
  fi
done

if [ "true" == "$doit" ]; then
  echo "changing password"
  echo -e -n "${cpwd}\n${p1}\n${p2}" | passwd
  result="$?"
  if [ "$result" != 0 ]; then
    echo "Authentication error. Password unchanged." | yad --title="Error" --borders=80 --text-info --button=gtk-close:0
    exit $result
  else
    echo "Password updated successfully." | yad  --title="Success" --borders=80 --text-info --button=gtk-close:0
    exit 0
  fi
fi

exit 1

