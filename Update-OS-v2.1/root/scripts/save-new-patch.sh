#!/bin/bash

echo "about to save new patch..."

# encoder wheel is ignored (until /gohome is called at end of script)
oscsend localhost 4001 /enableauxsub i 1

# clear aux screen
oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/aux/line/1 s "Saving New..."

# set to aux screen, signals screen update
oscsend localhost 4001 /oled/setscreen i 1

# signal patch to save state
oscsend localhost 4000 /saveState i 1

# allow patch to save stuff in state folder if it wants
sleep .25 

# get newest name
OLDNAME=$( ls /tmp/curpatchname )

# if it ends in numbers, assume it is already a copy so don't add more numbers
# remove a space followed by more numbers then start incrementing
BASENAME=$( echo "${OLDNAME}" | sed 's/ [0-9]\+$//' )

# start at 2 cause this will always be at least a sequel
N=2
NEWNAME="${BASENAME} ${N}"
while [[ -d "/usbdrive/Patches/${NEWNAME}" ]] ; do
    N=$(($N+1))
    NEWNAME="${BASENAME} ${N}"
done

echo $NEWNAME

# copy current patch to a new one
cp -Hr /tmp/patch/ "/usbdrive/Patches/${NEWNAME}"

# copy knobstate.txt and any other files saved by the patch
cp -r /tmp/state/* "/usbdrive/Patches/${NEWNAME}"

# reload
oscsend localhost 4001 /reload i 1
oscsend localhost 4001 /gohome i 1
oscsend localhost 4001 /loadPatch s "${NEWNAME}"


