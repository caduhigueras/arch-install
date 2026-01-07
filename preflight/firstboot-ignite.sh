#!/usr/bin/env bash

cp -a /root/arch-installer /mnt/opt/arch-installer
arch-chroot /mnt bash -c 'find /opt/arch-installer -maxdepth 1 -type f -name "*.sh" -exec chmod 0755 {} +'
arch-chroot /mnt chown -R root:root /opt/arch-installer

arch-chroot /mnt bash -c 'cat > /etc/systemd/system/firstboot-setup.service << "EOF"
[Unit]
Description=Run first boot setup once
After=network.target
Wants=network.target

[Service]
User=arch
Group=arch
Type=oneshot
WorkingDirectory=/opt/arch-installer
ExecStart=/opt/arch-installer/firstboot.sh
StandardOutput=journal+console
StandardError=journal+console
TTYPath=/dev/console
TTYReset=yes
TTYVHangup=yes
TTYVTDisallocate=yes
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
systemctl enable firstboot-setup.service'

echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" | arch-chroot /mnt tee "/etc/sudoers.d/99-$USERNAME-nopasswd" >/dev/null
arch-chroot /mnt chmod 0440 "/etc/sudoers.d/99-$USERNAME-nopasswd"

