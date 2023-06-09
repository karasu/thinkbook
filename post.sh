#!/bin/sh

ask_continue ()
{
  echo -n "Would you like to continue? (y/n) "
  read result
  if [ "$result" != "y" ]; then
    exit 0
  fi
}

##################################################################################
# Script starts here

INSTALL_DIR="/mnt/archinstall"

# Install arch install scripts (just in case)
pacman -Sy --needed --noconfirm arch-install-scripts

echo "We will chroot to $INSTALL_DIR"
ask_continue

arch-chroot $INSTALL_DIR

# Set user password
USR=`id -nu 1000`
echo "Enter user $USR password:"
passwd $USR

###################################################################################
# Installs AUR helper

YAY="/thinkbook/yay"

echo "Now we will Install yay using $USR user..."
ask_continue
pacman -Sy --needed --noconfirm go
git clone https://aur.archlinux.org/yay.git $YAY
chown -R $USR:$USR $YAY
cd $YAY
su -c 'makepkg -f --needed --noconfirm' $USR
pacman -U --needed --noconfirm yay-*-x86_64.pkg.tar.zst

###################################################################################
echo "Now we will add chaotic-aur repository to pacman..."
ask_continue

pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman -U --needed --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo "[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

###################################################################################
# Fonts
echo "Now will install some extra fonts..."
ask_continue

pacman -Sy --needed --noconfirm awesome-terminal-fonts \
  cantarell-fonts gnu-free-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji \
  noto-fonts-extra ttf-dejavu ttf-font-awesome ttf-ionicons ttf-liberation ttf-opensans \
  ttf-ubuntu-font-family ttf-ubuntu-mono-nerd ttf-ubuntu-nerd ttf-sourcecodepro-nerd \
  ttf-hack powerline-fonts ttc-iosevka ttf-jetbrains-mono-nerd

pacman -Sy --needed --noconfirm siji-ttf
# ttf-font-icons ttf-unicons

##################################################################################
# Installs zsh, omyzsh and starship

echo "Will install zsh, 
pacman -Sy --noconfirm --needed zsh starship

echo "Installing OH MY ZSH..."

chsh -s /bin/zsh $USR
chsh -s /bin/zsh root

wget -O /tmp/omzsh-install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
chmod +x /tmp/omzsh-install.sh

# Install for root
RUNZSH=no sh /tmp/omzsh-install.sh

# Install for user 1000
sudo -u $USR RUNZSH=no sh /tmp/omzsh-install.sh

# Install starship cross-shell
sudo pacman -Sy --noconfirm --needed starship
mkdir -p /root/.config /home/$USR/.config
starship preset pastel-powerline -o /root/.config/starship.toml
cp /root/.config/starship.toml /home/$USR/.config
chown $USR:$USR /home/$USR/.config/starship.toml

#################################################################################
# Install AUR packages

pacman -Sy --needed --noconfirm jq

PACKAGES=`jq '.aur[]' /thinkbook/aur.json`

for package in ${PACKAGES[@]}
do
  sudo -u $USR -- yay -S --needed --noconfirm $package
done

################################################################################
# Copy dot files

mv /thinkbook/disk/home/user /thinkbook/disk/home/$USR
cp -Rnv /thinkbook/disk/* /
chown -R $USR:$USR /home/$USR

###############################################################################
# clean conflicting portals
sudo -u $USR -- yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk

###############################################################################
# Add user to groups
gpasswd -a $USR seat
gpasswd -a $USR video
gpasswd -a $USR wheel

###############################################################################
# env vars

echo "LIBSEAT_BACKEND=logind" >> /etc/environment
echo "HYPRLAND_LOG_WLR=1" >> /etc/environment
echo "GTK_THEME=Manhattan:dark" >> /etc/environment
echo "QT_QPA_PLATFORM=wayland" >> /etc/environment

###############################################################################
# enable services
systemctl enable bluetooth
systemctl enable greetd
systemctl enable seatd
systemctl enable sshd

exit


