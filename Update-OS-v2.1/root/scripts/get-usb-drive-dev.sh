#!/bin/sh

# this returns the most recently plugged usb block device suitable for mounting

devices=(/dev/sd*)

if [ -e ${devices[-1]} ]; then 
    echo "${devices[-1]}"
    exit 0
else
    exit 1
fi


