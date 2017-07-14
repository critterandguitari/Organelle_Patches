#!/bin/sh

# I don't think this is actually necessary (shutting down Pd) ...
# If USB disk device was removed, Pd won't be able to save anything anyway.
# If MIDI device removed, MIDI won't work.  User will have to restart patch.

#oscsend localhost 4001 /oled/aux/clear i 1
#oscsend localhost 4001 /oled/aux/line/1 s "USB Device Removed!"
#oscsend localhost 4001 /oled/aux/line/3 s "Stopping patch..."
# set to aux screen which also causes screen refresh
#oscsend localhost 4001 /oled/setscreen i 1

#/root/scripts/killpd.sh
#oscsend localhost 4001 /oled/aux/line/3 s "Stopped patch."
#oscsend localhost 4001 /oled/setscreen i 1
#oscsend localhost 4001 /reload i 1
