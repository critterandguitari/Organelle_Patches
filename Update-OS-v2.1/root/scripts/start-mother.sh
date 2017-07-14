#!/bin/sh
clear
#cd /usbdrive
/root/scripts/killmother.sh
/root/scripts/setup.sh
#/root/scripts/check-for-usb-drive.sh
/root/scripts/mount.sh 
# check if mother is present in /usbdrive/System
if [ -f /usbdrive/System/mother ]; then
    echo "running mother from /usbdrive/System"
    /usbdrive/System/mother &
else
    echo "running mother from /root/"
    /root/mother &
fi
