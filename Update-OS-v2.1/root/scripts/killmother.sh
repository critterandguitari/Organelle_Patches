#!/bin/sh
# quit Pd 
/root/scripts/killpd.sh
# then mother
# give a chance to shut itself off
oscsend localhost 4001 /quitmother i 1
sleep .1

# kill SIGTERM 
killall mother
sleep .1

# and kill SIGKILL 
killall -s 9 mother

