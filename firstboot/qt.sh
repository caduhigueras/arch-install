#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm qt5-wayland qt6-wayland kvantum qt5ct qt6ct qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects qt5-svg

# Add Theme
git clone https://github.com/0xsch1zo/Kvantum-Tokyo-Night.git /home/arch/Downloads/qt-tokyonight
cd /home/arch/Downloads/qt-tokyonight
mkdir -p ~/.config/Kvantum
cp -r Kvantum-Tokyo-Night ~/.config/Kvantum/

cd /opt/arch-install

