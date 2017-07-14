#!/bin/bash

echo "Updating OS"

# checking the files
/usbdrive/Patches/Update-OS-v2.1/checkfiles.sh

OUT=$?
if [ $OUT -eq 0  ];then
    echo "files check out"
else
    echo "file issue"
    echo "error 1"
    exit 1
fi

# remount root read write
/root/scripts/remount-rw.sh

# copy files
cp -f /usbdrive/Patches/Update-OS-v2.1/root/mother.pd /root
cp -f /usbdrive/Patches/Update-OS-v2.1/root/mother /root
cp -f /usbdrive/Patches/Update-OS-v2.1/root/.bash_profile /root
cp -f /usbdrive/Patches/Update-OS-v2.1/root/.jwmrc /root
cp -f /usbdrive/Patches/Update-OS-v2.1/root/.pdsettings /root
cp -f /usbdrive/Patches/Update-OS-v2.1/root/version /root
cp -f /usbdrive/Patches/Update-OS-v2.1/root/scripts/* /root/scripts

# sync
sync 

# just chill
sleep 1

# let pd know
echo "sucess 1"

exit 0

# normally we'd want to remount read only, but this is not possible because of cp -f
# but pd patch will call shutdown after this anyway
