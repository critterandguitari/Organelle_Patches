#!/bin/sh

USER_DIR=${USER_DIR:="/usbdrive"}
PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
export FW_DIR=${FW_DIR:="/root"}
# SCRIPTS_DIR=$FW_DIR/scripts

# don't clear aux screen.  it is cleared and set with OG version 
# on first line before this script is called

USBDRIVE="$(grep usbdrive /proc/mounts | awk '{print $1}' | sed -e 's/\/dev\///')"

# second column on second line of output from aplaymidi -l is the name of the first attached MIDI device
MIDIDEV="$(aplaymidi -l | awk '{if (NR==2) print $2}')"

VERSION="$(cat $FW_DIR/version) $(cat $FW_DIR/buildtag)"

oscsend localhost 4001 /oled/setscreen i 1
oscsend localhost 4001 /oled/gClear ii 1 1
oscsend localhost 4001 /oled/gPrintln iiiiis  1 2 0 8 1 "     System Info"
oscsend localhost 4001 /oled/gFlip i 1
oscsend localhost 4001 /oled/aux/line/1 s "CPU: ..."
oscsend localhost 4001 /oled/aux/line/2 s "MIDI: $MIDIDEV"
oscsend localhost 4001 /oled/aux/line/3 s "Version: $VERSION"
oscsend localhost 4001 /oled/aux/line/4 s "Patch: $PATCH_DIR"
oscsend localhost 4001 /oled/aux/line/5 s "User: $USER_DIR"

# set to aux screen, signals screen update

# takes a sec for the cpu
CPU="$(echo $[100-$(vmstat 1 2|tail -1|awk '{print $15}')])"
oscsend localhost 4001 /oled/aux/line/1 s "CPU: $CPU %"
oscsend localhost 4001 /oled/setscreen i 1
