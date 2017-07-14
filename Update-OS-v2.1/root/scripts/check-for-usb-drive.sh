#!/bin/sh

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
