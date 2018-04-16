#!/bin/bash

export USER_DIR=${USER_DIR:="/usbdrive"}
export PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
export FW_DIR=${FW_DIR:="/root"}
export SCRIPTS_DIR=$FW_DIR/scripts


echo "Updating OS to " `cat ${IMAGE_DIR}/root/version` `cat ${IMAGE_DIR}/root/buildtag`
oscsend localhost 4001 /oled/line/2 s "Upgrading..."
oscsend localhost 4001 /oled/line/3 s "Checking files"

cd ${PATCH_DIR} 

mv UpdateOS-3.1/manifest.txt /tmp
find UpdateOS-3.1 -type f ! -name "._*" ! -name ".DS_Store" -print0  | xargs -0 sha1sum > /tmp/sha1sum.txt
sort /tmp/manifest.txt > /tmp/manifest.orig
sort /tmp/sha1sum.txt  > /tmp/manifest.new
diff /tmp/manifest.orig /tmp/manifest.new; ec=$?;

IMAGE_DIR=${PATCH_DIR}/UpdateOS-3.1
cd ${IMAGE_DIR}
#move manifest back, so can be attempted again !?
mv /tmp/manifest.txt .

if [ $ec -ne 0 ] 
then
    #tell user its all wrong ;) 
    export LOGFILE=${USER_DIR}/upgrade_log.txt
    echo "Upgrade failed for UpdateOS-3.1" > $LOGFILE
    echo "file diff incorrect" >> $LOGFILE
    diff /tmp/manifest.orig /tmp/manifest.new >> $LOGFILE
    oscsend localhost 4001 /oled/line/2 s "Upgrade failed: files"
    oscsend localhost 4001 /oled/line/3 s "Try downloading and"
    oscsend localhost 4001 /oled/line/4 s "running this patch"
    oscsend localhost 4001 /oled/line/5 s "again."
    $SCRIPTS_DIR/killpd.sh
    sleep 1
    exit 128
fi 


#switch to aux screen for deploy
oscsend localhost 4001 /oled/setscreen i 1
oscsend localhost 4001 /enableauxsub i 1
oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/aux/line/1 s "Installing"
oscsend localhost 4001 /oled/aux/line/5 s "Do not interrupt!"
./deploy.sh UpdateOS-3.1

# deploy.sh will shutdown