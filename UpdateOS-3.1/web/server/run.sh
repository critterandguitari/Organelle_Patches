#!/bin/sh


export SCRIPTS_DIR=~/scripts
export USER_DIR=`$SCRIPTS_DIR/get-user-dir.sh`
echo using USER_DIR: $USER_DIR


# start webserver
cd /root/web/server
python2 server.py 
