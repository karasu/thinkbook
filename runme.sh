#!/bin/sh

pacman -Sy wget
wget https://github.com/karasu/thinkbook/archive/refs/heads/main.tar.gz
tar xvf main.tar.gz
cd thinkbook-main
./install.sh
