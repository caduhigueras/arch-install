#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed obsidian

#todo add obsidian to bin
sudo touch /usr/local/bin/obsidian_sync
sudo chmod +x /usr/local/bin/obsidian_sync

sudo tee /usr/local/bin/obsidian_sync > /dev/null <<'EOF'
#!/bin/bash
cd /home/arch/.local/share/obsidian/
git fetch --all
git add .
git commit -m "Changes from home"
git push
EOF

sudo tee /etc/cron.d/sync_obsidian > /dev/null <<'EOF'
0 * * * * root /usr/local/bin/obsidian_sync
EOF

sudo chown root:root /etc/cron.d/sync_obsidian
sudo chmod 644 /etc/cron.d/sync_obsidian
