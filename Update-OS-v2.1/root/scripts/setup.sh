#!/bin/sh
sudo systemctl stop serial-getty@ttymxc0.service
sudo dmesg -n 1
sudo echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_govenor
amixer set PCM 192-
amixer set PCM 170+
amixer set Headphone 127-
amixer set Headphone 127+
amixer set 'Capture Mux' 'LINE_IN'

