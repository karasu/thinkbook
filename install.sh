#!/bin/sh

loadkeys es
pacman -S --noconfirm --needed python archinstall
ln -s /thinkbook/archinstall/profiles ~/.config/archinstall/profiles
python -m archinstall --config /thinkbook/archinstall/configuration.json --creds /thinkbook/archinstall/credentials.json --disk_layout /thinkbook/archinstall/disk_layout.json
