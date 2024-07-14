
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

# About Name

Yes. It's a play of words inspired by the name of the song from "The Jungle Book" 
performed by Louis Prima.

# License

BBN Marine OS and Lysmarine scripts distributed under GPLv3

Copyright © 2020 Frederic Guilbault

Copyright © 2021-2024 mgrouch

Included content copyrighted by other entities distributed under their respective licenses.
