#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm gtk3 gtk4 gtk-layer-shell gtk4-layer-shell
# yay -S --needed --noconfirm gtk-engine-murrine

git clone https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme /home/arch/Downloads/gtk-tokyonight
cd /home/arch/Downloads/gtk-tokyonight/themes
./install.sh

gsettings set org.gnome.desktop.interface icon-theme "TokyoNight-SE"

cd /home/arch/Downloads/
wget https://github.com/ljmill/tokyo-night-icons/releases/download/v0.2.0/TokyoNight-SE.tar.bz2
tar -xf TokyoNight-SE.tar.bz2
cp -r TokyoNight-SE /home/arch/.local/share/icons/

cd /opt/arch-installer
