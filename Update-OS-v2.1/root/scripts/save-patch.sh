#!/bin/sh

echo "about to save patch..."

# encoder wheel is ignored (until /gohome is called at end of script)
oscsend localhost 4001 /enableauxsub i 1

# clear aux screen
oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/aux/line/1 s "Saving..."

# set to aux screen, signals screen update
oscsend localhost 4001 /oled/setscreen i 1

# signal patch to save state
oscsend localhost 4000 /saveState i 1

# allow patch to save stuff in state folder if it wants
sleep .5

# copy knobstate.txt and any other files saved by the patch
cp -r /tmp/state/* "/tmp/patch"

# retrun to patch
oscsend localhost 4001 /oled/setscreen i 3

