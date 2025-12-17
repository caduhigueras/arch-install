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
sudo pacman -S --noconfirm --needed bat blueman bluez bluez-utils cairo dunst evince feh gum make nautilus nwg-look poppler-glib protobuf pv reflector ripgrep rsync satty sof-firmware stow  uwsm waybar wl-clipboard 
