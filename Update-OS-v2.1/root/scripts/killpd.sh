#!/bin/sh
# quit Pd in 3 steps

# give pd a chance to shut itself off
oscsend localhost 4000 /quitpd i 1
sleep .12

# kill pd SIGTERM 
killall pd
sleep .1

# and kill SIGKILL 
killall -s 9 pd

# turn off led, just to be sure
oscsend localhost 4001 /led i 0

# clean up
# remove old state directory
rm -fr /tmp/state
mkdir /tmp/state


