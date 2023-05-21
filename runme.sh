#!/bin/sh

pacman-key -u
pacman-key --populate
pacman -Sy --noconfirm archlinux-keyring
pacman -S --noconfirm --needed wget

#wget https://github.com/karasu/thinkbook/archive/refs/heads/main.tar.gz
#tar xvf main.tar.gz
#cd thinkbook-main

if [ "$1" == "sda" ]; then
  sed -i -e 's/nvme0n1/sda/g' archinstall/configuration.json
  sed -i -e 's/nvme0n1/sda/g' archinstall/disk_layout.json
fi

./install.sh

