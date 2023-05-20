#!/bin/sh

USR=`id -un 1000`

pacman -Sy --needed --noconfirm jq

PACKAGES=`jq '.aur[]' /thinkbook/post/aur.json`

for package in ${PACKAGES[@]}
do
  sudo -u $USR -- yay -S --needed --noconfirm $package
done
