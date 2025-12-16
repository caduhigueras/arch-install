#!/usr/bin/env bash

if ! command -v docker >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm docker
    sudo systemctl enable --now docker.service
    sudo usermod -aG docker ${USER}
    newgrp docker
fi

