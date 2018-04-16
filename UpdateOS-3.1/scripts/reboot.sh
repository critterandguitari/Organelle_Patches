#!/bin/sh

# USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
FW_DIR=${FW_DIR:="/root"}

oscsend localhost 4001 /oled/setscreen i 1

oscsend localhost 4001 /enableauxsub i 1
oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/aux/line/1 s "Rebooting...."
oscsend localhost 4001 /oled/aux/line/2 s "(~1 minute)"
oscsend localhost 4001 /oled/aux/line/5 s "Do not remove power!"

sync
sleep 1
SCRIPTS_DIR=$FW_DIR/scripts

$SCRIPTS_DIR/killpatch.sh
$SCRIPTS_DIR/killmother.sh
killall wpa_supplicant
killall dhcpcd
reboot
#echo "reboot"
