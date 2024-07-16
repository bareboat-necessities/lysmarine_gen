
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

# Set up

- Connect your NMEA 0183 boat device (wind instrument, etc) to RS-485 port of coremp135
- Connect your NMEA 2000 boat networks to CAN0 and/or CAN1 ports of coremp135
- Connect IMU supported by pypilot to i2c port of coremp135
- Connect pypilot motor controller to UART6 port of coremp135
- Connect USB GPS to another port of coremp135
- Connect mp135 to the router or ethernet switch via ethernet port 
- Connect keyboard to USB port
- Connect HDMI monitor
- Connect 12v power
- Power on. Wait for about 45 seconds on the first boot. 

NOTE: Do not connect USB3.0 devices to coremp135 USB2.0 ports. 

# Access from browser

You can access applications on your coremp135 from a browser running on the same network. 

NOTE: On your router you need to assign fixed IP address by MAC address to your coremp135, to avoid DHCP picking different IP addresses for coremp135. 

Hostname: coremp135

Different applications use different http ports. For signalk it's 3000,
for pypilot it's 8080, for victron web it's 8000. 




# About Name

Yes. It's a play of words inspired by the name of the song from "The Jungle Book" 
performed by Louis Prima.

# License

BBN Marine OS and Lysmarine scripts distributed under GPLv3

Copyright © 2020 Frederic Guilbault

Copyright © 2021-2024 mgrouch

Included content copyrighted by other entities distributed under their respective licenses.
