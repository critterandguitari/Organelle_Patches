#!/bin/sh
echo "Stopping pd, unmounting USB drive..."
oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/aux/line/1 s "Ejecting USB drive..."
oscsend localhost 4001 /oled/setscreen i 1
/root/scripts/killpd.sh
fuser -km /usbdrive/
umount /usbdrive
echo "done"
oscsend localhost 4001 /oled/aux/line/3 s "Safe to remove."
# set to aux screen signals screen update
oscsend localhost 4001 /oled/setscreen i 1
oscsend localhost 4001 /reload i 1
