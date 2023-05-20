#!/bin/sh

echo "Installing OH MY ZSH..."

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

USR=`id -un 1000`
chsh -s /bin/zsh $USR
chsh -s /bin/zsh root
