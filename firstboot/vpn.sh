#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm openvpn openfortivpn

sudo tee /etc/openfortivpn/config > /dev/null <<'EOF'
host = 
port = 10443
username = 
password = 
trusted-cert =
EOF

