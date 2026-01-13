#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm sddm sddm-kcm

cd /home/arch/.local/share/arch-dotfiles

sudo cp sddm/sddm.conf /etc/sddm.conf
sudo cp -r sddm/kr_minimal /usr/share/sddm/themes/
sudo chmod -R a+rX /usr/share/sddm/themes/kr_minimal

sudo mkdir -p /etc/sddm.conf.d
sudo touch /etc/sddm.conf.d/numlock.conf

sudo tee /etc/sddm.conf.d/numlock.conf > /dev/null <<'EOF'
[General]
Numlock=on
EOF

cd /opt/arch-installer
