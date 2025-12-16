#!/usr/bin/env bash

# Update the system
sudo pacman -Syy --noconfirm

# Install Yay
git clone https://aur.archlinux.org/yay.git ~/.local/share/yay
cd ~/.local/share/yay
makepkg -si

sudo pacman -S --noconfirm --needed blueman bluez bluez-utils cairo cronie dunst evince feh gum make nautilus nwg-look poppler-glib protobuf pv reflector ripgrep rsync satty sof-firmware stow systat uwsm waybar wl-clipboard 
