#!/bin/sh

# Runs all scripts

/thinkbook/post/yay.sh
/thinkbook/post/chaotic.sh
/thinkbook/post/fonts.sh
/thinkbook/post/omz.sh
/thinkbook/post/aur.sh
/thinkbook/post/disk.sh

USR=`id -nu 1000`
passwd $USR

