#!/bin/bash

CH=$(cat /usbdrive/MIDI-Config.txt | grep channel | sed "s/channel //" | sed s/\;//)

while read line; do
#    echo $line
        
    if [ "$line" == "/encoder/turn i 0" ]
    then
        CH=$(($CH-1))
        if (( $CH < 1 )); then
            CH=1
        fi
        echo $CH
        oscsend localhost 4001 /oled/aux/line/5 s "MIDI Channel: $CH"
    fi
    
    if [ "$line" == "/encoder/turn i 1" ]
    then 
        CH=$(($CH+1))
        if (( $CH > 16 )); then
            CH=16
        fi
        echo $CH
        oscsend localhost 4001 /oled/aux/line/5 s "MIDI Channel: $CH"
    fi

    if [ "$line" == "/encoder/button i 1" ]
    then 
        echo "channel $CH;" > /usbdrive/MIDI-Config.txt
        oscsend localhost 4000 /midich i $CH
        
        oscsend localhost 4001 /oled/aux/clear i 1
        oscsend localhost 4001 /oled/aux/line/2 s "MIDI Channel"
        oscsend localhost 4001 /oled/aux/line/3 s "set to ${CH}."
        exit
    fi


done


