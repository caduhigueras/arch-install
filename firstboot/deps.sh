#!/usr/bin/env bash

# Update the system
sudo pacman -Syy --noconfirm

# Install Yay
set -e
mkdir -p ~/.local/share
git clone https://aur.archlinux.org/yay.git ~/.local/share/yay
cd ~/.local/share/yay
makepkg -si --noconfirm --needed

# cronie 
sudo pacman -S --noconfirm --needed 7zip bat blueman bluez bluez-utils cairo cmake cpio cronie dunst evince feh ffmpeg gnome-calculator gum lsof make meson nautilus ntfs-3g nwg-look openssh openssl poppler-glib protobuf pv reflector ripgrep rsync satty sof-firmware stow tar unzip uwsm waybar wget wl-clipboard xclip zip
