ip link set wlan0 up
wpa_supplicant -D nl80211,wext -i wlan0 -c <(wpa_passphrase "name" "pass") &

