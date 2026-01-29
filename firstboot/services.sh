#!/usr/bin/env bash

sudo systemctl enable sddm
sudo systemctl enable bluetooth
sudo systemctl enable cronie.service
sudo systemctl start cronie.service
sudo systemctl disable firstboot-setup
sudo systemctl daemon-reload

#sudo sh -c "sudo rm -rf /etc/sudoers.d/99-$USER-nopasswd && reboot now"
sudo reboot now
