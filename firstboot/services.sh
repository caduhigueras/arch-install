#!/usr/bin/env bash

sudo systemctl enable sddm
sudo systemctl enable bluetooth
sudo systemctl enable cronie.service
sudo systemctl start cronie.service
sudo systemctl disable firstboot-setup
# sudo systemctl --user start elephant

# sudo rm -rf /etc/sudoers.d/99*

sudo cat > /etc/systemd/system/teams-notifications.service << "EOF"
[Unit]
Description=Teams notification listener

[Service]
ExecStart=teams-notification-listener
Restart=always

[Install]
WantedBy=default.target
EOF
sudo systemctl enable teams-focus-reset.service

sudo cat > /etc/systemd/system/teams-focus-reset.service << "EOF"
[Unit]
Description=Reset Teams unread counter on focus

[Service]
ExecStart=teams-reset-count-on-focus
Restart=always

[Install]
WantedBy=default.target
EOF
sudo systemctl enable teams-focus-reset.service

sudo reboot now
