
## What is BBN Marine OS

What started as an effort to build a marine linux OS turned out into much more interesting.
Our focus was to build a marine computer OS to be used on boats for the navigation and on touch screens in a cockpit of a boat.
By nature marine navigation is very demanding. Much more demanding than a car computer. There was a need for: 

* good touch screen support (even with small screens) (GTK3, budgie)
* ability to easily connect to a variety of sensors GPS, IMU, environment (temp, pressure, humidity, wind), autopilot, bilge water level, and much more (SignalK/Kplex NMEA are built-in)
* ability to control other hardware (started with controlling steering of the boat and autopilot). We have pyPilot built-in.
* weather information retrieving, processing, mapping and visualizing (it's often a matter of survival on a boat)
* weather routing and climatology
* a media player (who doesn't want to play some music being on a boat, so here we go with MPD player, Mopidy and more)
* internet connectivity, VPN, cellular 4G/LTE, satellite, Wi-Fi
* celestial navigation (brought us astronomy software, so we package Stellarium and more)
* cartography and navigation (We have OpenCPN, FreeBoard-SK, AvNav chart plotters). While our focus was marine charts, our distribution can be easily adapted for a car navigation system.
* software defined radio SDR (HAM radio community might take some interest), AIS, weather (NOAA, weather fax, NavTex), Inmarsat Fleet
* satellite internet via Iridium
* low power consumption (so we built it for the ARM based processors)

We would think our distribution can serve as a basis for others interested to build either:

* Home automation Linux distribution
* HAM radio SDR Linux distribution
* Weather station under Linux
* Astronomy related Linux distribution
* Music/Media player Linux distribution
* Generic Linux touch tablet on ARM raspberry OS
* Car specialized Linux distribution
* Wi-Fi router

The code for building this distribution is easily customizable following instructions below.
You do not have to build it on your own ARM hardware. The process described below explains how you
can make it to build it directly from your source code on GitHib via CircleCi and distribute it on CloudSmith
or other place. It doesn't take that much effort or coding, some dedication required (surely).

# Awards

<img src="https://www.realvnc.com/wp-content/uploads/2023/07/RealVNC-RPi-Prize-logo.png" alt="RealVNC RPi Prize logo" width="75%"/>

Third place in RealVNC Raspberry Pi Prize 2023.

# Download

To get start it's easier to download pre-built image using the links below (or you can build your own 
following instructions in the next chapter).
Download location for releases on GitHub https://github.com/bareboat-necessities/lysmarine_gen/releases

NOTE: Do not forget to set Wi-Fi country after the installation.

[Getting Started Guide](https://bareboat-necessities.github.io/my-bareboat/bareboat-os.html). 

# BBN Marine OS Documentation

Getting Started:
https://bareboat-necessities.github.io/my-bareboat/bareboat-os.html

# Bareboat Necessities (BBN) Marine OS Forum

Bareboat Necessities Marine OS Forum:
https://github.com/bareboat-necessities/lysmarine_gen/discussions

## BBN OS Issues

https://github.com/bareboat-necessities/lysmarine_gen/issues

# System Requirements

* Raspberry Pi 4 or higher (or CM4 module 4Gb with Wi-Fi, or raspberry pi 400)
* 4 GB memory or higher (2 GB works too but not for many concurrent programs)
* Touchscreen with resolution 1024x600 or higher and size 10" or more (800x480 and 7" works too but few of the programs will open too big dialog boxes)
* Suitable (unless you find something better) waterproof touchscreen display for your cockpit (TouchThink TPC-CD-M101, 10.1", 1280x800, IP65): https://www.touchtecs.com/
* Wi-Fi and LTE/4G router (not a requirement, gl-x750 Spitz OpenWrt router): https://www.gl-inet.com/products/gl-x750/
* Quark-elec Marine multiplexers seems has a good product line (or you can just use this BBN OS image but
considering all waterproof connectors and hardware customization these commercial multiplexers be nicer choice):
https://www.quark-elec.com/product-category/marine/multiplexers/ Another (even cheaper) option: http://www.yakbitz.com/
* More about hardware: https://bareboat-necessities.github.io/my-bareboat/


# Passwords

Default passwords are set to 'changeme', which you are supposed to change.
Default username in login screens is 'user'.


# Screenshots

![Lysmarine BBN Screen1](img/bbn-screen1.png?raw=true "BBN Marine OS Screen1")

![Lysmarine BBN Screen2](img/bbn-screen2.png?raw=true "BBN Marine OS Screen2")

![Lysmarine BBN Screen3](img/bbn-screen3.png?raw=true "BBN Marine OS Screen3")

![Lysmarine BBN Screen4](img/bbn-screen4.png?raw=true "BBN Marine OS Screen4")

# BBN Marine OS installation video

[![IMAGE ALT TEXT](http://img.youtube.com/vi/3zMjUs2X3qU/0.jpg)](https://www.youtube.com/v/3zMjUs2X3qU?playlist=3zMjUs2X3qU&autoplay=1&loop= "Pi on a boat")

# Brief list of applications included:

## Navigation, Instruments

- [OpenCPN](https://opencpn.org/) and plugins
- [AvNav](https://github.com/wellenvogel/avnav)
- [GPSD](https://en.wikipedia.org/wiki/Gpsd)
- [KPlex](http://www.stripydog.com/kplex/)
- [SignalK](https://signalk.org/) and plugins
- [Freeboard-SK](https://github.com/SignalK/freeboard-sk)
- [SK Instrument Panel](https://github.com/SignalK/instrumentpanel)
- [KIP Dashboard](https://github.com/mxtommy/Kip)
- [PyPilot](https://pypilot.org/)
- [BBN Launcher](https://github.com/bareboat-necessities/lysmarine_gen/tree/master/install-scripts/4-server/files/bbn-launcher)
- [XyGrib](https://opengribs.org/en/xygrib) Weather GRIB Viewer App
- [Stellarium](http://stellarium.org/)
- [CanBoat](https://github.com/canboat)
- [Sail CAD](http://www.sailcut.com/)
- [Race Instructions / Planning App](http://boats.sourceforge.net/)
- Vessel Specs App
- ColReg 
- [Sailing Trip and Provisioning Checklist](https://bareboat-necessities.github.io/my-bareboat/bareboat-equipment-checklist)
- [JTides](https://arachnoid.com/JTides/)
- [PC-NavTex](https://github.com/juerec/pc-navtex)


## Internet

- Chromium Web Browser
- Email Client
- FB Messenger [Caprine](https://github.com/sindresorhus/caprine)
- YouTube App
- Facebook App
- Internet Weather
- Dockwa (Mooring and Marina Booking App)
- NauticEd (Sailing Education)
- Lightning Maps
- Windy
- Marine Traffic


## Multimedia

- [Mopidy](https://mopidy.com/) Media Player with Web UI (YouTube, Local List, Internet Radio, MPD support)
- [MusicBox](https://mopidy.com/ext/musicbox-webclient/) (Music Player)
- [Iris](https://github.com/jaedb/Iris) (Music Player)
- [VLC](https://www.videolan.org/vlc/) (with IP camera support)
- [Audacious](https://github.com/audacious-media-player)
- [MotionEye](https://github.com/ccrisan/motioneye) (Cameras Control)
- [shairport-sync](https://github.com/mikebrady/shairport-sync) (AirPlay)
- [raspotify](https://github.com/dtcooper/raspotify) (Raspotify)
- [Jellyfin](https://jellyfin.org/) (Jellyfin)


## Radio

- [Cubic SDR](https://cubicsdr.com/)
- [Flarq](http://www.w1hkj.com/flarq_main.html)
- [Fldigi](http://www.w1hkj.com/)
- [GNU Radio Companion](https://github.com/gnuradio/gnuradio)
- [CuteSdr](https://directory.fsf.org/wiki/Cutesdr)
- [GPredict](http://gpredict.oz9aec.net/)
- [Gqrx](https://gqrx.dk/)
- [Hamfax RadioFax](http://hamfax.sourceforge.net/)
- [JNX NavText](https://arachnoid.com/JNX/)
- [JWX WeatherFax](https://arachnoid.com/JWX/)
- [noaa-apt satellite weather](https://noaa-apt.mbernardi.com.ar/)
- [PreviSat Satellite Tracker](http://previsat.sourceforge.net/)
- [Quisk SDR](https://james.ahlstrom.name/quisk/)
- [multimon-ng](https://github.com/EliasOenal/multimon-ng), netcat
- [Chirp](https://chirp.danplanet.com/)
- [GNU AIS](http://gnuais.sourceforge.net/)
- [DireWolf](https://github.com/wb2osz/direwolf)
- [YAAC](https://www.ka2ddo.org/ka2ddo/YAAC.html)
- [morse2ascii](https://packages.ubuntu.com/bionic/morse2ascii)
- [APRX](https://github.com/PhirePhly/aprx)
- [PiAware](https://flightaware.com/adsb/piaware/)
- [APM Planner 2](https://ardupilot.org/planner2/)
- RTL AIS
- RTL-SDR
- GNSS-SDR
- HackRF
- AirSpy
- OsmoSDR
- soapysdr-tools


## Protocols

- [Samba (Windows Networking)](https://www.samba.org/)
- CUPS (printing)
- VNC (remote desktop)
- SSH (remote shell)
- NMEA 0183
- SocketCAN, NMEA 2000, [can-utils](https://github.com/linux-can/can-utils)
- [OpenVPN (Virtual Private Networking)](https://openvpn.net/)
- MQTT [Mosquitto](https://mosquitto.org/) for IoT (to talk to Sonoff smart switches to switch on several devices like Radar,
Windlass, Bow Thruster, Lights)
- Wi-Fi (Access Point and Client)
- [SignalK](https://signalk.org/)
- Seatalk 1, GPIO
- ModBus (to talk to Victron Venus OS, etc.)
- [Timeshift](https://github.com/teejee2008/timeshift) (backups), [rsync](https://rsync.samba.org/)
- PPP, wvdial, picocom for satellite modem support
- I2C tools
- 1-Wire (sensors i.e. for temperature, humidity, pressure, tank levels)
- LoRaWan
- WeatherFax
- NOAA Weather
- NavTex
- Inmarsat Fleet
- WinLink
- SMS (Using Gammu)
- Bluetooth (File Transfer)
- AirPlay (via shairport-sync)


## Tools

- Text Editor
- File Manager
- Task Manager
- Terminal Application
- Image Viewer
- Calculator
- Calendar
- Weather App
- [OnBoard](https://launchpad.net/onboard) touch screen keyboard
- [Right click support on touchscreens](https://github.com/bareboat-necessities/evdev-right-click-emulation)
- [Arduino IDE](https://www.arduino.cc/en/software)
- [Java (OpenJDK)](https://openjdk.java.net/)
- [Python](https://www.python.org/)
- [NodeJS](https://nodejs.org/en/)
- C/C++ Compiler and Toolset
- Debian, NPM, PIP, Snap package managers
- [rpi-clone](https://github.com/billw2/rpi-clone) (SSD cloning)
- Pi Imager, piclone
- [seahorse](https://wiki.debian.org/Seahorse) (Password Management)
- [Gammu](https://wammu.eu/smsd/) (SMS Client)
- [Timeshift](https://github.com/teejee2008/timeshift) (backups)
- [scrcpy](https://github.com/Genymobile/scrcpy) (Android Mirroring)


## Data

- [InfluxDB](https://www.influxdata.com/)
- [Grafana](https://grafana.com/)
- [NodeRed embedded into SignalK](https://nodered.org/)
- [Chronograf](https://github.com/influxdata/chronograf)
- [Kapacitor](https://github.com/influxdata/kapacitor)


## Add-ons via install scripts

- [QtVlm](https://www.meltemus.com/)
- [DeskPi Pro](https://github.com/DeskPi-Team/deskpi) support
- Text-To-Speech App
- Touchscreen calibration
- [NMEA Sleuth Chromium Plugin](https://chrome.google.com/webstore/detail/nmea-sleuth/pkikkfglomloligndkaibecgapljgjok?hl=en)
- PACTOR
- [SdrGlut](https://github.com/righthalfplane/SdrGlut)
- [WxToImg](https://wxtoimgrestored.xyz/)
- OS Settings
- Timezone Setup
- Change Password
- Predict (Satellite Tracker for scripting)
- [Pat / WinLink](https://github.com/la5nta/pat)
- [Airmail](http://siriuscyber.net/airmail/)
- [Widevine](https://www.widevine.com/) Digital Content Protection
- [Homeassistant](https://www.home-assistant.io/) Home Automation
- [EspHome](https://esphome.io/) Home Automation


This is the fork of the original LysMarine https://github.com/lysmarine/lysmarine_gen by Frederic Guilbault.
It is based on the LysMarine OS, but differs from it in a number of included applications, and the UI features.
Now it is a distinct OS image.

Another useful resource is our previous project (see: https://bareboat-necessities.github.io/my-bareboat/).
Although it is based on OpenPlotter it still is useful to understand hardware and software set up of your marine
raspberry pi.


# Steps to create your own BBN Marine OS image

* Create GitHub account
* Fork this project on GitHub
* Create CircleCi account (Use logging in with GitHub)
* Register .circleci/config.yml in CircleCi
* Create CloudSmith account (Use logging in with GitHub)
* Import CloudSmith key into circleci project settings (via env variable)
* Edit publish-cloudsmith.sh options in .circleci/config.yml to put location of your cloudsmith repository and push the changes into GitHub
* After circleci build completes it will create and upload image to cloudsmith
* You can burn this image using RaspberryPi imager to SD card and use that SD card to boot your raspberry Pi
* You can edit files inside install-scripts directory push them into GitHub and customize your image.

# About Name

Yes. It's a play of words inspired by the name of the song from "The Jungle Book" 
performed by Louis Prima.

# License

BBN Marine OS and Lysmarine scripts distributed under GPLv3

Copyright © 2020 Frederic Guilbault

Copyright © 2021-2025 mgrouch

Included content copyrighted by other entities distributed under their respective licenses.
