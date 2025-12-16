echo "Configure boot manager"
arch-chroot /mnt pacman -S --noconfirm --needed grub efibootmgr
arch-chroot /mnt grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg


