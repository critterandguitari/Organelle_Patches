#!/bin/bash

export FW_DIR=${FW_DIR:="/root"}
export SCRIPTS_DIR=$FW_DIR/scripts

# remount root read write
/root/scripts/remount-rw.sh

IMAGE_DIR=`pwd`

#remove the default critter git user
if grep critter  /root/.gitconfig ; then rm /root/.gitconfig; fi

# copy files
oscsend localhost 4001 /oled/aux/line/3 s "Copying files"
cp -f ${IMAGE_DIR}/root/mother.pd /root
cp -f ${IMAGE_DIR}/root/mother.scd /root
cp -f ${IMAGE_DIR}/root/mother /root
cp -f ${IMAGE_DIR}/root/version /root
cp -f ${IMAGE_DIR}/root/buildtag /root
cp -f ${IMAGE_DIR}/scripts/* /root/scripts
cp -f ${IMAGE_DIR}/externals/* /root/externals
mkdir -p /root/web
rm -fr /root/web/*  #remove old stuff in web
cp -fr ${IMAGE_DIR}/web/* /root/web

# install extra software
cd ${IMAGE_DIR}/extra

# install stuff for AP mode, web stuff, avahi
oscsend localhost 4001 /oled/aux/line/3 s "Installing Packages"
pacman -U --needed --noconfirm ./pkg/*.pkg.tar.xz

# install cherry py and pyliblo
oscsend localhost 4001 /oled/aux/line/3 s "Upgrading PIP"
pip2 install --upgrade --no-index --find-links=./python pip # gotta upgrade pip otherwise pyliblo doesn't install
oscsend localhost 4001 /oled/aux/line/3 s "Installing CherryPy"
pip2 install --no-index --find-links=./python cherrypy
oscsend localhost 4001 /oled/aux/line/3 s "Installing PyLibLo"
pip2 install --no-index --find-links=./python pyliblo


# system config
oscsend localhost 4001 /oled/aux/line/3 s "Configuring..."
cp -f ${IMAGE_DIR}/root/.bash_profile /root
cp -f ${IMAGE_DIR}/root/.jwmrc /root
cp -f ${IMAGE_DIR}/root/.pdsettings /root

mkdir -p /root/.ssh
cp -f ${IMAGE_DIR}/.ssh/environment /root/.ssh/environment
cp -f ${IMAGE_DIR}/system/etc/ssh/sshd_config /etc/ssh/sshd_config
cp -f ${IMAGE_DIR}/system/lib/systemd/system/cherrypy.service /lib/systemd/system/cherrypy.service

# config for avahi
cp -f ${IMAGE_DIR}/system/etc/nsswitch.conf /etc/nsswitch.conf

# enable avahi
systemctl start avahi-daemon
systemctl enable avahi-daemon
systemctl daemon-reload

# config for supercollider
mkdir -p /root/.config/SuperCollider
cp -f ${IMAGE_DIR}/.config/SuperCollider/* /root/.config/SuperCollider

oscsend localhost 4001 /oled/aux/line/2 s "Done"
oscsend localhost 4001 /oled/aux/line/3 s " "



cd ${PATCH_DIR}
rm -rf ${IMAGE_DIR}

sync

echo "root:organelle" | chpasswd

# sync
sync 

#shutdown
exit 3
