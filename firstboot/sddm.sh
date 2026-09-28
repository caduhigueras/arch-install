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

# Lets wallpaper-toggle (bin/) sync the login screen background unattended --
# needs bin/ already stowed to /usr/local/bin, which dotfiles.sh does earlier
# in firstboot.sh's run order.
sudo install -m 0440 -o root -g root \
  sddm/sudoers.d/arch-dotfiles-sddm-wallpaper /etc/sudoers.d/
sudo visudo -c

# Seed the theme's background with whatever themes.sh (also earlier in the
# run order) picked as the initial wallpaper, instead of leaving the repo's
# checked-in placeholder bg.jpg.
sudo sddm-sync-wallpaper

cd /opt/arch-installer
