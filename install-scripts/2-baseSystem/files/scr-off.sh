#!/bin/bash

. /usr/local/m5stack/bashrc

echo 70 > /sys/class/backlight/axp2101_m5stack_bl/brightness
sleep 600
echo 0 > /sys/class/backlight/axp2101_m5stack_bl/brightness

# erase screen
cat /dev/zero > /dev/fb1 2>&1 || true
