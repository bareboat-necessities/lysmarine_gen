#!/bin/bash

. /usr/local/m5stack/bashrc

echo 70 > /sys/class/backlight/axp2101_m5stack_bl/brightness
sleep 600
echo 0 > /sys/class/backlight/axp2101_m5stack_bl/brightness

printf "q\r\n" | fbv /usr/local/m5stack/1x1-black.jpg > /dev/null 2>&1
