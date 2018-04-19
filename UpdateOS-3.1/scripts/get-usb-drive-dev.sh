#!/bin/sh

# USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
# FW_DIR=${FW_DIR:="/root"}
# SCRIPTS_DIR=$FW_DIR/scripts

# this returns the most recently plugged usb block device suitable for mounting

devices=(/dev/sd*)

if [ -e ${devices[-1]} ]; then 
    echo "${devices[-1]}"
    exit 0
else
    exit 1
fi


