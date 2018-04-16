#!/bin/sh

# USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
export FW_DIR=${FW_DIR:="/root"}
SCRIPTS_DIR=$FW_DIR/scripts


# quit patch
$SCRIPTS_DIR/killpatch.sh
# then mother
# give a chance to shut itself off
oscsend localhost 4001 /quitmother i 1
sleep .1


#kill webserver if running
kill  `cat /tmp/webserver.pid`
sleep .1
kill -9 `cat /tmp/webserver.pid`

# kill SIGTERM 
killall mother
sleep .1

# and kill SIGKILL 
killall -s 9 mother

