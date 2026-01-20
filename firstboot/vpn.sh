#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm openvpn openfortivpn networkmanager network-manager-applet nm-connection-editor networkmanager-openvpn

sudo tee /etc/openfortivpn/config > /dev/null <<'EOF'
host = 
port = 10443
username = 
password = 
trusted-cert =
EOF

