# Arch Guide

loadkeys es

# Vars

USERNAME="karasu"

INSTALL_DEV="/dev/nvme0n1"
BOOT_PART="/dev/nvme0n1p1"
ROOT_PART="/dev/nvme0n1p2"

PARTED="parted -s -f -a optimal"

EAP_IDENTITY="W08044624"
EAP_PASSWORD="r2tjo0m3ka"

PACMAN="pacman -S --needed --noconf"
INSTALL_ZST="pacman -U --needed --noconf"

# Prepare disk

${PARTED} ${INSTALL_DEV} -- mklabel gpt \
    mkpart myboot fat32 1MiB 512MiB \
    mkpart myroot btrfs 512MiB -1s

# Create filesystems
mkfs.vfat ${BOOT_PART}
mkfs.btrfs ${ROOT_PART}

# Mount install destination
mkdir /mnt
mount ${ROOT_PART} /mnt

mkdir /mnt/boot
mount ${BOOT_PART} /mnt/boot

# Install base systemm
pacstrap /mnt base base-devel linux linux-firmware btrfs-progs intel-ucode intel-media-driver

# Setup /etc/fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into new installed system
arch-chroot /mnt

# Install firmwares
${PACMAN} linux-firmware-bnx2x linux-firmware-liquidio linux-firmware-mellanox \
    linux-firmware-nfp linux-firmware-qlogic linux-firmware-whence aic94xx-firmware \
    mkinitcpio-firmware sof-firmware wd719x-firmware                   

# Install some base tools
${PACMAN} grub nano sudo dhcpcd greetd iwd os-prober ntfs-3g git wget

# zsh
${PACMAN} zsh zsh-completions powerline zsh-autosuggestions \
    zsh-syntax-highlighting zsh-powerlevel10k lsd

# Generate locales
sed 's/#en_US.UTF8 UTF-8/en_US.UTF8 UTF-8/g' /etc/locale.gen
sed 's/#ca_ES.UTF8 UTF-8/ca_ES.UTF8 UTF-8/g' /etc/locale.gen

locale-gen
localectl set-locale ca_ES.UTF8

ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc

# Install bootloader
grub-install ${INSTALL_DEV}
grub-mkconfig -o /boot/grub/grub.cfg

# Users
passwd
useradd -m -g users -G wheel -s /bin/zsh ${USERNAME}
passwd ${USERNAME}

export EDITOR="nano"

# Add group wheel to sudoers
sed 's/# %wheel/%wheel/g' /etc/sudoers

systemctl enable dhcpcd
systemctl enable greetd

# iwd (wifi)
echo "[Security]
EAP-Method=PEAP
EAP-Identity=${EAP_IDENTITY}
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=${EAP_IDENTITY}
EAP-PEAP-Phase2-Password=${EAP_PASSWORD}
[Settings]
AutoConnect=true" > /var/lib/iwd/gencat_ENS_EDU.8021x

# yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -s
${INSTALL_ZST} *.zst
cd ..

# greetd
${PACMAN} greetd

echo '[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd hypr"
user = "greeter"' >> /etc/greetd/config.toml

# greetd tuigreet
git clone https://aur.archlinux.org/greetd-tuigreet-bin.git
cd greetd-tuigreet-bin
makepkg -s
${INSTALL_ZST} *.zst
cd ..

# hyperland
${PACMAN} base-devel gdb ninja gcc cmake libxcb xcb-proto xcb-util \
    xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender \
    pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm \
    xorg-xwayland cmake wlroots mesa git meson polkit lxqt-policykit wofi \
    waybar jq wayland-utils wdisplays

# Install from Aur
git clone https://aur.archlinux.org/hyprland-bin.git
cd hyprland-bin
makepkg -s
${INSTALL_ZST} *.zst
cd ..

# Hyprpaper
git clone https://github.com/hyprwm/hyprpaper  
cd hyprpaper  
make all  
sudo cp build/hyprpaper /usr/local/bin 
cd ..

# Misc stuff (personal choices)
${PACMAN} kitty zathura neofetch openssh p7zip pavucontrol

# themeing
${PACMAN} pop-icon-theme capitaine-cursors breeze-icons

git clone https://aur.archlinux.org/fantome-gtk.git
cd fantome-gtk
makepkg -s
${ZST} 

gsettings set org.gnome.desktop.interface icon-theme Pop  
#gsettings set org.gnome.desktop.interface gtk-theme Fantome
gsettings set org.gnome.desktop.interface cursor-theme capitaine-cursors

# Full QT libraries
${PACMAN} qt5 qt6

# alsa (audio)
${PACMAN} alsa-lib alsa-plugins alsa-tools alsa-utils alsa-firmware
gpasswd -a ${USERNAME} audio

# pipewire (audio)
${PACMAN} pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack

# openal
${PACMAN} openal realtime-privileges

# fonts
${PACMAN} adobe-source-code-pro-fonts awesome-terminal-fonts cantarell-fonts \
    gnu-free-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
    siji-ttf ttf-dejavu ttf-font-awesome ttf-font-icons ttf-ionicons \
    ttf-liberation ttf-ms-win10-auto ttf-opensans ttf-sourcecodepro-nerd \
    ttf-unicons powerline-fonts ttc-iosevka

# Gimp (devel)
#gimp-devel

# Github Desktop
# github-desktop-bin

# Google Chrome
# google-chrome

# Software packages
${PACMAN} grim feh ffmpegthumbnailer file-roller gnome-tweaks jre-openjdk lxqt-policykit \
    mesa-utils vulkan-intel mlocate moc mpv mtools neofetch nfs-utils nitrogen \
    youtube-dl zathura-pdf-poppler zathura zsh zsh-completions zsh-autosuggestions \
    zsh-syntax-highlighting zsh-theme-powerlevel10k imv

# Multimedia graph framework
${PACMAN} gst-plugin-pipewire gst-plugins-base gst-plugins-bad gst-plugins-good \
    gst-plugins-ugly

# Thunar
${PACMAN} thunar thunar-archive-plugin thunar-volman tumbler

# Lutris
#${PACMAN} lutris MangoHud MangoHud-32bit wine winetricks wine-32bit mesa-dri-32bit \
#    libGL-32bit amdvlk amdvlk-32bit vkd3d vkd3d-devel vkd3d-32bit vulkan-loader \
#    vulkan-loader-32bit libX11-devel libX11-devel-32bit libgpg-error libgpg-error-32bit \
#    gdk-pixbuf gdk-pixbuf-32bit libgcc libgcc-32bit libglvnd libglvnd-32bit 
