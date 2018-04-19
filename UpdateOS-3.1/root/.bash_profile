#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
# to startx in read only root fs
export XAUTHORITY=/var/tmp/.Xauthority_$USER

ps cax | grep mother > /dev/null
if [ $? -eq 0 ]; then
    echo "Welcome to Organelle."
else
    /root/scripts/setup.sh > /dev/null 2>&1
    /root/scripts/start-mother.sh > /dev/null 2>&1
    /root/scripts/welcome.sh
fi
