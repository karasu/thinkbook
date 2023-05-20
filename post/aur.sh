#!/bin/sh

pacman -Sy --needed --noconfirm jq

PACKAGES=`jq '.aur[]' /thinkbook/post/aur.json`

for package in ${PACKAGES[@]}
do
  yay -S --needed --noconfirm $package
done
