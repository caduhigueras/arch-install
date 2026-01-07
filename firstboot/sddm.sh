#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm sddm sddm-kcm

cd /home/arch/.local/share/arch-dotfiles

sudo cp sddm/sddm.conf /etc/sddm.conf
sudo cp -r sddm/kr_minimal /usr/share/sddm/themes/
sudo chmod -R a+rX /usr/share/sddm/themes/kr_minimal

cd /opt/arch-installer
