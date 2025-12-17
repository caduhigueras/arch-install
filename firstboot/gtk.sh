#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm gtk3 gtk4 gtk-layer-shell gtk4-layer-shell
yay -S --needed --noconfirm gtk-engine-murrine

git clone https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme /home/arch/Downloads/gtk-tokyonight
cd /home/arch/Downloads/gtk-tokyonight/themes
./install.sh

cd /opt/arch-install

gsettings set org.gnome.desktop.interface icon-theme "TokyoNight-SE"
