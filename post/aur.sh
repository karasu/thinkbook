#!/bin/sh

pacman -Sy --needed --noconfirm jq

PACKAGES=`jq '.aur[]' /thinkbook/post/aur.json`

for package in ${PACKAGES[@]}
do
  pacman -S --needed --noconfirm $package
done
