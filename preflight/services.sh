#!/usr/bin/env bash

arch-chroot /mnt systemctl enable dhcpcd
arch-chroot /mnt systemctl enable NetworkManager
arch-chroot /mnt systemctl enable iwd
