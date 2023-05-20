#!/bin/sh

USR=`id -un 1000`

mv /thinkbook/post/disk/home/user /thinkbook/post/disk/home/$USR
cp -Rnv /thinkbook/post/disk/* /
