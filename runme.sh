#!/bin/sh

loadkeys es
pacman -Sy --noconfirm
pacman -S --noconfirm git python archinstall wget

wget https://github.com/karasu/thinkbook-archinstall/archive/refs/heads/main.tar.gz
tar xvfz main.tar.gz

cd thinkbook-archinstall-main

python -m archinstall --config archinstall/configuration.json --creds archinstall/credentials.json --disk_layouts archinstall/disk_layout.json
