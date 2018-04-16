#!/bin/bash
killall wpa_supplicant
killall dhcpcd
/root/scripts/create_ap --no-virt -n wlan0 Organelle coolmusic
