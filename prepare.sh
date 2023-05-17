#!/bin/sh

pacman -Sy wget
wget https://github.com/karasu/thinkbook-archinstall/archive/refs/heads/main.tar.gz
tar xvf main.tar.gz
cd thinkbook-archinstall-main
./install.sh
