#!/bin/sh

# USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
# FW_DIR=${FW_DIR:="/root"}
# SCRIPTS_DIR=$FW_DIR/scripts

for i in 1 2 3 4 5
do
    if grep -qs " /usbdrive" /proc/mounts; then
        echo "USB drive mounted"
        exit 1
    else
        echo "checking for USB drive"
    fi
    sleep 1
done
echo "USB drive not mounted"
exit 0
