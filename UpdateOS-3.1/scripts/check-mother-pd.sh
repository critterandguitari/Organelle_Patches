#!/bin/sh

# USER_DIR=${USER_DIR:="/usbdrive"}
# PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
# FW_DIR=${FW_DIR:="/root"}
# SCRIPTS_DIR=$FW_DIR/scripts

# usage $1 mother.pd file to check,  $2 version number requried

VER=` awk '\
    BEGIN { meta=0 } \
    /canvas.*META.*/ { meta = 1 } \
    /text.*VERSION.*/ { if (meta==1) { FS=" ;" ; print $6; } } \
    /restore.*META.*/ { meta = 0} \
'  < $1 | tr -d \; `

if [ "$VER" == "$2" ]
then 
    exit 0
fi
    echo mother.pd not required version, require "$2" got "$VER"
exit -1





