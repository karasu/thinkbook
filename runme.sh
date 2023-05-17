#!/bin/sh

pacman -Sy --noconfirm wget
wget https://github.com/karasu/thinkbook/archive/refs/heads/main.tar.gz
tar xvf main.tar.gz
cd thinkbook-main

if [ "$1" == "sda" ]; then
  sed -i -e 's/nvme0n1/sda/g' configuration.json
  sed -i -e 's/nvme0n1/sda/g' disk_layout.json
fi

./install.sh

