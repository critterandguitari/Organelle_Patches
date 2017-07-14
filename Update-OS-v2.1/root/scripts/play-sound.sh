#!/bin/sh

rm /tmp/sound.wav
ln -s "$1" /tmp/sound.wav
/usr/lib/pd/tcl/pd-gui.tcl /root/sfplayer.pd

