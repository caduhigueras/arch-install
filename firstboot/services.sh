#!/usr/bin/env bash

sudo systemctl enable sddm
sudo systemctl enable bluetooth
sudo systemctl enable cronie.service
sudo systemctl start cronie.service
sudo systemctl disable firstboot-setup
# sudo systemctl --user start elephant

# sudo rm -rf /etc/sudoers.d/99*

sudo reboot now
