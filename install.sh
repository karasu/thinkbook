#!/bin/sh

loadkeys es
pacman -S --noconfirm --needed python python-pip git
pip uninstall archinstall
git clone https://github.com/archlinux/archinstall /archinstall
cd /archinstall
pip install
cd /thinkbook
python -m archinstall --config /thinkbook/archinstall/configuration.json --creds /thinkbook/archinstall/credentials.json --disk_layout /thinkbook/archinstall/disk_layout.json
