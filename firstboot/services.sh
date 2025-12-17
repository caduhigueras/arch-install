#!/usr/bin/env bash

sudo systemctl enable sddm
sudo systemctl enable bluetooth
sudo systemctl enable cronie.service
sudo systemctl start cronie.service
systemctl --user enable --now hypridle.service

