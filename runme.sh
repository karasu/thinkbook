#!/bin/sh

# TESTING ONLY
#########################################################################
if [ ! -f "/etc/pacman.d/mirrorlist.backup" ]; then
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
    echo "Server = http://10.1.1.166:8000\n" > /etc/pacman.d/mirrorlist
    cat /etc/pacman.d/mirrorlist.backup >> /etc/pacman.d/mirrorlist
fi
#########################################################################

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

# If there is a failed installation /mnt/archinstall needs to be unmounted

umount -R /mnt/archinstall

./install.sh
