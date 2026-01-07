#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed xdg-desktop-portal-hyprland hyprpolkitagent hyprpaper hyprlock hypridle hyprshot
sudo pacman -S --noconfirm --needed hyprland xorg
yay -S --needed --noconfirm hyprcap

# hyprpm update
# yes | hyprpm add https://github.com/levnikmyskin/hyprland-virtual-desktops  && hyprpm enable virtual-desktops
# TODO: move to dotfiles
# exec-once = bash -lc 'test -f ~/.cache/hyprpm-vd-installed || (hyprpm update && hyprpm add https://github.com/levnikmyskin/hyprland-virtual-desktops && touch ~/.cache/hyprpm-vd-installed)'
# exec-once = hyprpm enable virtual-desktops || true

