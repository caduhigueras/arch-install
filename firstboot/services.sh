#!/usr/bin/env bash

sudo systemctl enable sddm
sudo systemctl enable bluetooth
sudo systemctl enable cronie.service
sudo systemctl start cronie.service
sudo systemctl disable firstboot-setup

cat <<'EOF' | sudo tee /etc/systemd/system/teams-notifications.service >/dev/null
[Unit]
Description=Teams notification listener

[Service]
ExecStart=/usr/local/bin/teams-notification-listener
Restart=always

[Install]
WantedBy=multi-user.target
EOF

cat <<'EOF' | sudo tee /etc/systemd/system/teams-focus-reset.service >/dev/null
[Unit]
Description=Reset Teams unread counter on focus

[Service]
ExecStart=/usr/local/bin/teams-reset-count-on-focus
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now teams-notifications.service
sudo systemctl enable --now teams-focus-reset.service

sudo rm -rf "/etc/sudoers.d/99-arch-nopasswd"
sudo reboot now
