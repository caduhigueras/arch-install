#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed xdg-desktop-portal-hyprland hyprpolkitagent hyprpaper hyprlock hypridle hyprcap hyprshot
sudo pacman -S --noconfirm --needed hyprland xorg
yay -S --needed --noconfirm hyprcap

hyprpm update

yes | hyprpm add https://github.com/levnikmyskin/hyprland-virtual-desktops  && hyprpm enable virtual-desktops
