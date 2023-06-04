#!/bin/sh

loadkeys es
pacman -S --noconfirm --needed python archinstall
python -m archinstall --config /thinkbook/archinstall/configuration.json --creds /thinkbook/archinstall/credentials.json --disk_layout /thinkbook/archinstall/disk_layout.json
