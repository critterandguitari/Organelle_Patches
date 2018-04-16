#!/bin/sh

# export PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
export FW_DIR=${FW_DIR:="/root"}
export SCRIPTS_DIR=$FW_DIR/scripts

if grep -qs "/usbdrive" /proc/mounts 
then
    export USER_DIR=/usbdrive
else 
    if grep -qs "/sdcard" /proc/mounts 
    then 
        export USER_DIR=/sdcard
    else
        # not practical, as its not mounted, but we have no choice
        export USER_DIR=/usbdrive
    fi
fi

echo $USER_DIR
