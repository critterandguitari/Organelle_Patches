#!/bin/sh

# USER_DIR=${USER_DIR:="/usbdrive"}
export PATCH_DIR=${PATCH_DIR:="/usbdrive/Patches"}
export FW_DIR=${FW_DIR:="/root"}
export SCRIPTS_DIR=$FW_DIR/scripts

jwm -exit
$SCRIPTS_DIR/start-mother.sh > /dev/null 2>&1
$SCRIPTS_DIR/welcome.sh
