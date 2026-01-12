#!/usr/bin/env bash

echo "Sorting mirrors based on location"
pacman -Syy
pacman -S --noconfirm --needed python reflector
reflector --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

echo "Install base system"

pacstrap -K /mnt base linux-lts linux-firmware

arch-chroot /mnt touch /etc/vconsole.conf

echo "Generate swapfile"
arch-chroot /mnt bash -c 'mkswap -U clear --size 32G --file /swapfile && swapon /swapfile'

echo "Generate FSTAB file"
genfstab -U /mnt >> /mnt/etc/fstab

echo "Install initial dependencies and libraries"
arch-chroot /mnt bash -c 'pacman -S --noconfirm --needed vim nano sudo iwd dhcpcd git base-devel networkmanager'


# Intel or AMD
CPU_VENDOR="$(awk -F: '/vendor_id/ {gsub(/^[ \t]+/, "", $2); print $2; exit}' /proc/cpuinfo)"
UCODE_PKG=""
case "$CPU_VENDOR" in
  GenuineIntel) UCODE_PKG="intel-ucode" ;;
  AuthenticAMD) UCODE_PKG="amd-ucode" ;;
  *) UCODE_PKG="" ;;
esac

echo "Setting timezones and locales"
arch-chroot /mnt pacman -S --noconfirm --needed "$UCODE_PKG"
#arch-chroot /mnt timedatectl set-timezone Europe/Madrid
arch-chroot /mnt ln -sf "/usr/share/zoneinfo/$TZ" /etc/localtime
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt timedatectl set-ntp true
arch-chroot /mnt sed -i 's/^#\?\(en_US\.UTF-8 UTF-8\)$/\1/' /etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt bash -c 'echo LANG=en_GB.UTF-8 > /etc/locale.conf'

echo "Setting users and hosts"
arch-chroot /mnt bash -c 'echo ArchLinux > /etc/hostname'
printf 'root:%s\n' "$ROOT_PW" | arch-chroot /mnt chpasswd
arch-chroot /mnt useradd -m "$USERNAME"
printf '%s:%s\n' "$USERNAME" "$ROOT_PW" | arch-chroot /mnt chpasswd
unset ROOT_PW
arch-chroot /mnt usermod -aG wheel,audio,video,storage "$USERNAME"
echo '%wheel ALL=(ALL:ALL) ALL' | arch-chroot /mnt tee /etc/sudoers.d/10-wheel >/dev/null
arch-chroot /mnt chmod 440 /etc/sudoers.d/10-wheel
