#!/bin/sh

loadkeys es
pacman -S python archinstall
python -m archinstall --config archinstall/configuration.json --creds archinstall/credentials.json --disk_layouts archinstall/disk_layout.json
