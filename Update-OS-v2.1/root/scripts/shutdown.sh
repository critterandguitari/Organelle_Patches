#!/bin/sh
oscsend localhost 4001 /shutdown i 1
/root/scripts/killpd.sh
/root/scripts/killmother.sh
killall wpa_supplicant
killall dhcpcd
shutdown -h now
#echo "shjutting down"
