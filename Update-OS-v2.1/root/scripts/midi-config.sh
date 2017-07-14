#!/bin/bash


# encoder wheel is ignored (until /gohome is called at end of script)
oscsend localhost 4001 /enableauxsub i 1

# clear aux screen
oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/setscreen i 1

# get current channel, create channel file if it doesn't exist
CH=1
if [ -f /usbdrive/MIDI-Config.txt ]; then
    CH=$(cat /usbdrive/MIDI-Config.txt | grep channel | sed "s/channel //" | sed s/\;//)
else
    echo "channel 1;" > /usbdrive/MIDI-Config.txt
    CH=$(cat /usbdrive/MIDI-Config.txt | grep channel | sed "s/channel //" | sed s/\;//)
fi

oscsend localhost 4001 /oled/aux/line/1 s "Set the default"
oscsend localhost 4001 /oled/aux/line/2 s "MIDI input / output"
oscsend localhost 4001 /oled/aux/line/3 s "channel."
oscsend localhost 4001 /oled/aux/line/5 s "MIDI Channel: $CH"

/root/scripts/oscdump2 4002 | /root/scripts/set-midi-ch.sh

sleep 2

echo "cool set the ch"

#oscsend localhost 4001 /gohome i 1
oscsend localhost 4001 /oled/setscreen i 2


