#!/bin/sh

# USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
# FW_DIR=${FW_DIR:="/root"}
# SCRIPTS_DIR=$FW_DIR/scripts

# this returns the most recently plugged usb block device suitable for mounting
devices=(/dev/sd*)
if [ -e ${devices[-1]} ]; then 
    DEVICE="${devices[-1]}"
    echo "found USB drive, using ${DEVICE}"
else
    echo "no usb drive device found!"
    exit 1
fi

# test that this device isn't already mounted
if grep -qs "$DEVICE " /proc/mounts; then
   echo "${DEVICE} is already mounted"
   exit 1
fi

# also test /usbdrive isn't mounted
# this should warn to eject or something..
if grep -qs " /usbdrive" /proc/mounts; then
   echo "/usbdrive is already mounted"
   exit 1
fi


# pull in useful variables from vol_id, quote everything Just In Case
eval `/sbin/blkid -o udev ${DEVICE} | sed 's/^/export /; s/=/="/; s/$/"/'`

if [ -z "$ID_FS_TYPE" ]; then
   echo "error: ID_FS_LABEL is empty! did vol_id break? tried ${DEVICE}"
   exit 1
fi

# mount the device
# 
# If expecting thumbdrives, you probably want 
#      mount -t auto -o async,noatime [...]
# 
# If drive is VFAT/NFTS, this mounts the filesystem such that all files
# are owned by a std user instead of by root.  Change to your user's UID
# (listed in /etc/passwd).  You may also want "gid=1000" and/or "umask=022", eg:
#      mount -t auto -o uid=1000,gid=1000 [...]
# 
# 
case "$ID_FS_TYPE" in

   vfat)  mount -t vfat -o async,noatime,uid=1000 ${DEVICE} "/usbdrive"
          ;;

   exfat)  mount -t exfat -o async,noatime,uid=1000 ${DEVICE} "/usbdrive"
          ;;


          # I like the locale setting for ntfs
   ntfs)  mount -t auto -o async,noatime,uid=1000,locale=en_US.UTF-8 ${DEVICE} "/usbdrive"
          ;;

          # ext2/3/4 don't like uid option
   ext*)  mount -t auto -o async,noatime ${DEVICE} "/usbdrive"
          ;;
esac

# all done here, return successful
exit 0

