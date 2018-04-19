#!/bin/bash

USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
export FW_DIR=${FW_DIR:="/root"}
SCRIPTS_DIR=$FW_DIR/scripts

# encoder wheel is ignored (until /gohome is called at end of script)
oscsend localhost 4001 /enableauxsub i 1

# clear aux screen
oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/setscreen i 1


MIDIFILE=$USER_DIR/MIDI-Config.txt 

# get current channel, create channel file if it doesn't exist
CH=1
if [ -f $MIDIFILE ]
then
    CH=$(cat $MIDIFILE | grep channel | sed "s/channel //" | sed s/\;//)
else
    echo "channel 1;" > $MIDIFILE
    CH=$(cat $MIDIFILE | grep channel | sed "s/channel //" | sed s/\;//)
fi

oscsend localhost 4001 /oled/aux/line/1 s "Set the default"
oscsend localhost 4001 /oled/aux/line/2 s "MIDI input / output"
oscsend localhost 4001 /oled/aux/line/3 s "channel."
oscsend localhost 4001 /oled/aux/line/5 s "MIDI Channel: $CH"

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
        grep -v "channel" $MIDIFILE > $MIDIFILE.tmp
        echo "channel $CH;" >> $MIDIFILE.tmp
        mv $MIDIFILE.tmp $MIDIFILE
        oscsend localhost 4000 /midich i $CH
        
        oscsend localhost 4001 /oled/aux/clear i 1
        oscsend localhost 4001 /oled/aux/line/2 s "MIDI Channel"
        oscsend localhost 4001 /oled/aux/line/3 s "set to ${CH}."
        oscsend localhost 4001 /enableauxsub i 0
        oscsend localhost 4001 /midiConfig i 1
        break 2
    fi
done < <($SCRIPTS_DIR/oscdump2 4002)
echo returned from setmidich

killall oscdump2
sleep 2

echo "cool set the ch"

#oscsend localhost 4001 /gohome i 1
oscsend localhost 4001 /oled/setscreen i 2


