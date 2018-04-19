#!/bin/bash

#in case the deploy scripts need these
export USER_DIR=${USER_DIR:="/usbdrive"}
export PATCH_DIR=${PATCH_DIR:="$USER_DIR/Patches"}
export FW_DIR=${FW_DIR:="/root"}
export SCRIPTS_DIR=$FW_DIR/scripts

oscsend localhost 4001 /oled/setscreen i 1

oscsend localhost 4001 /enableauxsub i 1
oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/aux/line/1 s "Installing"
oscsend localhost 4001 /oled/aux/line/2 s "$1"
oscsend localhost 4001 /oled/aux/line/5 s "Do not interrupt!"

echo "installing : " $1 
cd "$PATCH_DIR"

export INSTALL_FILE="$1"


rm ._*.z?p


INSTALL_DIR=`unzip -l "$INSTALL_FILE" -x "__MACOSX/*" "._*" ".DS_Store" | head -4 |tail -1 | cut -b 31- |cut -d '/' -f 1`

echo "install dir :  $INSTALL_DIR"
if [ "$INSTALL_DIR" == "" ] 
then
    oscsend localhost 4001 /oled/aux/line/4 s "Install FAILED"
    oscsend localhost 4001 /oled/aux/line/5 s "unable no files"
    oscsend localhost 4001 /enableauxsub i 0
    exit 130
fi

rm -rf $INSTALL_DIR

oscsend localhost 4001 /oled/aux/line/4 s "unzipping"
unzip -o "$INSTALL_FILE" -x "__MACOSX/*" "._*" ".DS_Store"> /tmp/install_files.txt ; ec=$?;
if [ $ec -ne 0 ]
then
    oscsend localhost 4001 /oled/aux/line/4 s "Install FAILED"
    oscsend localhost 4001 /oled/aux/line/5 s "unable to unzip"
    oscsend localhost 4001 /enableauxsub i 0
    exit 128
fi



ec=0

if [ -f "$INSTALL_DIR/manifest.txt" ]
then
    oscsend localhost 4001 /oled/aux/line/4 s "Checking manifest"
    mv "$INSTALL_DIR/manifest.txt" /tmp
    find "$INSTALL_DIR" -type f ! -name "._*" ! -name ".DS_Store" -print0  | xargs -0 sha1sum > /tmp/sha1sum.txt
    sort /tmp/manifest.txt > /tmp/manifest.orig
    sort /tmp/sha1sum.txt  > /tmp/manifest.new
    diff /tmp/manifest.orig /tmp/manifest.new; ec=$?; 
    mv /tmp/manifest.txt "$INSTALL_DIR"
    if [ $ec -ne 0 ] 
    then
        export LOGFILE=${USER_DIR}/install_log.txt
        echo "Install failed for $INSTALL_FILE" > $LOGFILE
        echo "file diff incorrect" >> $LOGFILE
        diff /tmp/manifest.orig /tmp/manifest.new >> $LOGFILE
        oscsend localhost 4001 /oled/aux/line/4 s "Install FAILED"
        oscsend localhost 4001 /oled/aux/line/5 s "Files corrupt"
        oscsend localhost 4001 /enableauxsub i 0
        exit 129 
    fi 
fi

if [ -f "$INSTALL_DIR/deploy.sh" ]
then
    oscsend localhost 4001 /oled/aux/line/4 s "Running deploy"
    cd "$INSTALL_DIR"
    ./deploy.sh "$INSTALL_DIR" ; ec=$?
    if [ $ec -gt 127 ] 
    then
        oscsend localhost 4001 /enableauxsub i 0
        oscsend localhost 4001 /oled/aux/line/4 s "Install FAILED"
        oscsend localhost 4001 /oled/aux/line/5 s "deploy failed"
        oscsend localhost 4001 /enableauxsub i 0
        exit $ec
    fi
fi

#success

#remove zip file
cd "$PATCH_DIR"
rm "$INSTALL_FILE"

oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/aux/line/1 s "Installation"
oscsend localhost 4001 /oled/aux/line/2 s "Successful"
oscsend localhost 4001 /oled/aux/line/3 s "Enjoy :)" 
case "$ec" in
    0)
        oscsend localhost 4001 /oled/aux/line/5 s "restarting mother" 
        sleep 1
        ~/scripts/restart-mother.sh
    ;;
    1)
        oscsend localhost 4001 /oled/aux/line/5 s "restarting mother" 
        sleep 1
        ~/scripts/restart-mother.sh
    ;;
    2)
        oscsend localhost 4001 /oled/aux/line/5 s "rebooting..."
        sleep 1
        ~/scripts/reboot.sh
    ;;
    3)
        oscsend localhost 4001 /oled/aux/line/5 s "shutting down..."
        sleep 1
        ~/scripts/shutdown.sh
    ;;
esac

#irrelevant we dont get here :) 
oscsend localhost 4001 /enableauxsub i 0
exit $ec

