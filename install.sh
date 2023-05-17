#!/bin/sh

loadkeys es
pacman -S --noconfirm python archinstall
python -m archinstall --config archinstall/configuration.json --creds archinstall/credentials.json --disk_layout archinstall/disk_layout.json
