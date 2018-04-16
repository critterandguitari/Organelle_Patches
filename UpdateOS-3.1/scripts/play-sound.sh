#!/bin/sh

# USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
# FW_DIR=${FW_DIR:="/root"}
# SCRIPTS_DIR=$FW_DIR/scripts

rm /tmp/sound.wav
ln -s "$1" /tmp/sound.wav
/usr/lib/pd/tcl/pd-gui.tcl /root/sfplayer.pd

