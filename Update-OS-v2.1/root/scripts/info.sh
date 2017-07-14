#!/bin/sh

# don't clear aux screen.  it is cleared and set with OG version 
# on first line before this script is called

USBDRIVE="$(grep usbdrive /proc/mounts | awk '{print $1}' | sed -e 's/\/dev\///')"

# second column on second line of output from aplaymidi -l is the name of the first attached MIDI device
MIDIDEV="$(aplaymidi -l | awk '{if (NR==2) print $2}')"

VERSION="$(cat /root/version)"

oscsend localhost 4001 /oled/aux/line/1 s "Version: $VERSION"
oscsend localhost 4001 /oled/aux/line/2 s "MIDI: $MIDIDEV"
oscsend localhost 4001 /oled/aux/line/3 s "USB drive: $USBDRIVE"
oscsend localhost 4001 /oled/aux/line/4 s "CPU: ..."
oscsend localhost 4001 /oled/aux/line/5 s " "

# set to aux screen, signals screen update
oscsend localhost 4001 /oled/setscreen i 1

# takes a sec for the cpu
CPU="$(echo $[100-$(vmstat 1 2|tail -1|awk '{print $15}')])"
oscsend localhost 4001 /oled/aux/line/4 s "CPU: $CPU %"
oscsend localhost 4001 /oled/setscreen i 1
