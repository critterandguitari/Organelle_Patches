#!/bin/sh

# USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
# FW_DIR=${FW_DIR:="/root"}
# SCRIPTS_DIR=$FW_DIR/scripts

# quiting patches
# 3 stages, inform by osc, then kill SIGTERM, then SIGKILL
# currently legacy pd is included


# give patch an opportunity to quit/cleanup
oscsend localhost 4000 /quitpd i 1
oscsend localhost 4000 /quit i 1
sleep .12

#kill all with SIGTERM
killall pd
kill `cat /tmp/pids/*.pid`
sleep .1

# and kill all with SIGKILL 
killall -s 9 pd
kill -9 `cat /tmp/pids/*.pid`


rm /tmp/pids/*.pid

# turn off led, just to be sure
oscsend localhost 4001 /led i 0

# clean up
# remove old state directory
rm -fr /tmp/state
mkdir /tmp/state


