#!/bin/sh

# USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
FW_DIR=${FW_DIR:="/root"}
SCRIPTS_DIR=$FW_DIR/scripts

echo "Stopping pd, unmounting USB drive..."
oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/aux/line/1 s "Ejecting USB drive..."
oscsend localhost 4001 /oled/setscreen i 1
$SCRIPTS_DIR/killpatch.sh

if grep -qs " /usbdrive" /proc/mounts; then
    fuser -km /usbdrive/
    umount /usbdrive
fi

echo "done"
oscsend localhost 4001 /oled/aux/line/3 s "Safe to remove."
# set to aux screen signals screen update
oscsend localhost 4001 /oled/setscreen i 1
oscsend localhost 4001 /reload i 1
