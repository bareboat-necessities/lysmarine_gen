
# What is BBN Marine OS for CoreMP135

BBN Marine OS for CoreMP135 is a lightweight version of BBN Marine OS
(https://github.com/bareboat-necessities/lysmarine_gen) designed for CoreMP135 from m5stack.
When loaded on CoreMP135 it turns CoreMP135 into a low-power consuming boat computer appliance 
which is able to interface with NMEA 2000 (via CAN ports), NMEA 0183 via RS-485.

You can easily connect IMU to make a heading sensor.
You can connect PyPilot motor controller to USART6 port of CoreMP135 to make your own autopilot unit.
You can access it via a browser to see boat dashboards typical for marine MFDs.

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

Running SignalK with many connections and PyPilot motor controller at same time on CoreMP135 is not a good idea.
Disabling SignalK is suggested if you intend to use PyPilot as an autopilot. 
In that case enable PyPilot NMEA 0183 direct connection to /dev/ttySTM3 RS-485
(/home/pypilot/.pypilot/nmea0device)

# Download

Binaries are downloadable from:
<https://cloudsmith.io/~bbn-projects/repos/bbn-repo/packages/?q=bbn-coremp135>

[![Hosted By: Cloudsmith](https://img.shields.io/badge/OSS%20hosting%20by-cloudsmith-blue?logo=cloudsmith&style=for-the-badge)](https://cloudsmith.com)

Package repository hosting is graciously provided by [Cloudsmith](https://cloudsmith.com).
Cloudsmith is the only fully hosted, cloud-native, universal package management solution, that
enables your organization to create, store and share packages in any format, to any place, with total
confidence.

# Set up

Download the image file following 'Download' link above. Prepare SD card with the image.
You can use Balena Etcher or Raspberry Pi imager to burn the image to an SD card.
SD Card should be 'high endurance' ot 'industrial' grade to survive accidental losses of power.
SD card size of 32GB or more is recommended.

- Connect your NMEA 0183 boat device (wind instrument, etc) to RS-485 port of coremp135 (/dev/ttySTM3)
- Connect your NMEA 2000 boat networks to CAN0 and/or CAN1 ports of coremp135
- Connect IMU supported by pypilot to i2c port of coremp135
- Connect pypilot motor controller to UART6 port of coremp135 (/dev/ttySTM0)
- Connect USB GPS to another USB 2.0 port of coremp135
- Connect keyboard to USB port
- Connect HDMI monitor
- Connect mp135 to the router or ethernet switch via ethernet port
- Insert SD card with burned image
- Connect 12v power
- Power on. Give it few minutes during which the system will reboot a couple of times 

NOTE: Many steps above are optional except of the last four ones.

NOTE: The default password for the root account is 'changeme'.

NOTE: Do not connect USB3.0 devices to coremp135 USB2.0 ports. 

NOTE: If you are not using PyPilot as an autopilot, you can still use it as a heading source by connecting 
and calibrating pypilot supported i2c IMU (calibration is done via pypilot web UI). 
You do not need to connect pypilot motor controller in that case.

NOTE: RS-485 (NMEA0183) connection might need change of baud rate to match your device. You 
can do it in SignalK connections settings.

NOTE: Built-in LCD screen turns off after 10 mins after boot to save power.

# Access from browser

You can access applications on your coremp135 from a browser running on the same network. 

NOTE: On your router you need to assign fixed IP address by MAC address to your coremp135, to avoid DHCP picking different IP addresses for coremp135. 

Hostname: coremp135

Access using a web browser using http://coremp135.local/

Different applications use different http ports:

- for the main web desktop it's 80 
- for SignalK it's 3000
- for PyPilot it's 8080
- for Victron web it's 8000

# Serial console

You can use USB-C port to access coremp135 via serial console. Baud rate 115200.

# Pictures

<p align="center">
<img src="img/bbn-coremp135.png?raw=true" alt="BBN Marine OS UI on CoreMP135" />
</p>

<p align="center">
<img src="img/bbn-on-coremp135.png?raw=true" alt="BBN Marine OS on CoreMP135" />
</p>

# About Name

Yes. It's a play of words inspired by the name of the song from "The Jungle Book" 
performed by Louis Prima.

# License

BBN Marine OS and Lysmarine scripts distributed under GPLv3

Copyright © 2020 Frederic Guilbault

Copyright © 2021-2024 mgrouch

Included content copyrighted by other entities distributed under their respective licenses.
