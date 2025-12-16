#!/usr/bin/env bash

source ./preflight/disks.sh
source ./preflight/system.sh
source ./preflight/bootmanager.sh
source ./preflight/services.sh
source ./preflight/firstboot-ignite.sh

umount -l /mnt/boot
umount -l /mnt
reboot now
