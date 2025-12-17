#!/usr/bin/env bash

cp -a /root/arch-installer /mnt/opt/arch-installer

arch-chroot /mnt bash -c 'cat > /etc/systemd/system/firstboot-setup.service << "EOF"
[Unit]
Description=Run first boot setup once
After=network-online.target
Wants=network-online.target
[Service]
Type=oneshot
ExecStart=/opt/arch-installer/firstboot.sh
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF
systemctl enable firstboot-setup.service'
