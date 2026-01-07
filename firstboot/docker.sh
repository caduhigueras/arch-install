#!/usr/bin/env bash

if ! command -v docker >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm docker docker-compose
    sudo systemctl enable --now docker.service
    sudo usermod -aG docker ${USER}
    sudo chgrp docker /usr/bin/docker-compose
    sudo chmod +x /usr/bin/docker-compose
    # newgrp docker
fi

