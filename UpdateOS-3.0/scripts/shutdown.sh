#!/bin/sh

# USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
FW_DIR=${FW_DIR:="/root"}
SCRIPTS_DIR=$FW_DIR/scripts


oscsend localhost 4001 /shutdown i 1
$SCRIPTS_DIR/killpatch.sh
$SCRIPTS_DIR/killmother.sh

# shutdown wifi
wpa_cli -i wlan0 terminate
dhcpcd -b -x wlan0 
/root/scripts/create_ap --stop wlan0 

shutdown -h now
#echo "shutting down"
