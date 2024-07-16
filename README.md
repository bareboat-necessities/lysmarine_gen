
# What is BBN Marine OS for CoreMP135

BBN Marine OS for CoreMP135 is a Debian OS image for CoreMP135 from M5Stack.

It includes:

- SignalK
- PyPilot
- GPSd
- Kplex
- Canboat
- Victron WEB UI

# SignalK usage

CoreMP135 has only 512GB RAM. You won't be able to handle traffic with SignalK having
too many paths, like 1000s of AIS targets, etc

Running SignalK and PyPilot motor controller at same time on CoreMP135 is not a good idea.
Disable SignalK if you intend using PyPilot as an autopilot.

# Download

Binaries are downloadable from:
<https://cloudsmith.io/~bbn-projects/repos/bbn-repo/packages/?q=bbn-coremp135>

[![Hosted By: Cloudsmith](https://img.shields.io/badge/OSS%20hosting%20by-cloudsmith-blue?logo=cloudsmith&style=for-the-badge)](https://cloudsmith.com)

Package repository hosting is graciously provided by [Cloudsmith](https://cloudsmith.com).
Cloudsmith is the only fully hosted, cloud-native, universal package management solution, that
enables your organization to create, store and share packages in any format, to any place, with total
confidence.

# Set up

Download the image file following 'Download' link below.
You can use Balena Etcher or Raspberry Pi imager to burn image to the SD card.

- Connect your NMEA 0183 boat device (wind instrument, etc) to RS-485 port of coremp135
- Connect your NMEA 2000 boat networks to CAN0 and/or CAN1 ports of coremp135
- Connect IMU supported by pypilot to i2c port of coremp135
- Connect pypilot motor controller to UART6 port of coremp135
- Connect USB GPS to another port of coremp135
- Connect mp135 to the router or ethernet switch via ethernet port 
- Connect keyboard to USB port
- Connect HDMI monitor
- Insert SD card with burned image
- Connect 12v power
- Power on. Wait for about 45 seconds on the first boot. 

NOTE: Do not connect USB3.0 devices to coremp135 USB2.0 ports. 

# Access from browser

You can access applications on your coremp135 from a browser running on the same network. 

NOTE: On your router you need to assign fixed IP address by MAC address to your coremp135, to avoid DHCP picking different IP addresses for coremp135. 

Hostname: coremp135

Different applications use different http ports:

- for SignalK it's 3000
- for PyPilot it's 8080
- for Victron web it's 8000

# Serial console

You can use USB-C port to access coremp135 via serial console. Baud rate 115200.

# About Name

Yes. It's a play of words inspired by the name of the song from "The Jungle Book" 
performed by Louis Prima.

# License

BBN Marine OS and Lysmarine scripts distributed under GPLv3

Copyright © 2020 Frederic Guilbault

Copyright © 2021-2024 mgrouch

Included content copyrighted by other entities distributed under their respective licenses.
