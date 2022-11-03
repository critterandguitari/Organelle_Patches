#!/bin/sh

# this script run by Organelle ZOP package installer 

# Organelle 1 is identified by archarm in os release
grep -q 'ID=archarm' /etc/os-release; 
if [ $? -eq 0 ] 
then 
   oscsend localhost 4001 /oled/aux/line/1 s "Installing for"
   oscsend localhost 4001 /oled/aux/line/2 s "Organelle 1"
   
   # install for organelle 1
   cp main-og1.pd main.pd
   sleep 2
   exit 1
fi

# Organelle M is identified by a hw file with the line ogm in the firmware directory
grep -q 'ogm' $FW_DIR/hw; 
if [ $? -eq 0 ] 
then 
   oscsend localhost 4001 /oled/aux/line/1 s "Installing for"
   oscsend localhost 4001 /oled/aux/line/2 s "Organelle M / S"
   
   # install for organelle M
   cp main-oms.pd main.pd
   sleep 2
   exit 1
fi

