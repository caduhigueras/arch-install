#!/usr/bin/env bash

sudo systemctl enable sddm
sudo systemctl enable bluetooth
sudo systemctl enable cronie.service
sudo systemctl start cronie.service

sudo rm "/etc/sudoers.d/99-$USERNAME-nopasswd"
