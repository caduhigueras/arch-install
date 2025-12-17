#!/bin/bash

require gum
require sfdisk
require lsblk
require blockdev
require partprobe
require udevadm
require mkfs.fat
require mkfs.ext4
require mount

if [[ $EUID -ne 0 ]]; then
  echo "Run as root (or with sudo)." >&2
  exit 1
fi

# Pick a disk
DISK="$(
  lsblk -dpno TYPE,NAME,SIZE,MODEL \
  | awk '$1=="disk"{ $1=""; sub(/^ +/, ""); print }' \
  | gum choose --header "Select target DISK (THIS WILL ERASE IT)"
)"
DISK="${DISK%% *}" # first field (/dev/...)

gum confirm "ERASE ALL DATA on ${DISK} and create partitions?" || exit 0

# Ask about backup
BACKUP_GB="0"
if gum confirm "Do you want a backup partition?"; then
  BACKUP_GB="$(gum input --prompt "Backup size (GB): " --placeholder "e.g. 50")"
  [[ "$BACKUP_GB" =~ ^[0-9]+$ ]] || { echo "Backup size must be an integer GB." >&2; exit 1; }
fi

prompt_password() {
  local user="$1"
  local p1 p2

  while true; do
    p1="$(gum input --password --prompt "Password for ${user}: ")"
    p2="$(gum input --password --prompt "Confirm password for ${user}: ")"

    [[ -n "$p1" ]] || { gum style --foreground 1 "Password cannot be empty."; continue; }
    [[ "$p1" == "$p2" ]] || { gum style --foreground 1 "Passwords do not match. Try again."; continue; }

    printf '%s' "$p1"
    return 0
  done
}

# Ask username and password
USERNAME="$(gum input --prompt "Choose your username: " --placeholder "e.g. arch")"
ROOT_PW="$(prompt_password root)"

# Timezone
DEFAULT_TZ="Europe/Madrid"
TZ="$(
  { printf '%s\n' "$DEFAULT_TZ"; timedatectl list-timezones; } \
  | awk '!seen[$0]++' \
  | gum filter --placeholder "Timezone" --value "$DEFAULT_TZ"
)"


# Helpers
partpath() {
  local n="$1"
  if [[ "$DISK" =~ [0-9]$ ]]; then
    echo "${DISK}p${n}"   # nvme0n1p1
  else
    echo "${DISK}${n}"    # sda1
  fi
}

SECTOR_SIZE="$(cat "/sys/block/$(basename "$DISK")/queue/logical_block_size")"
TOTAL_SECTORS="$(blockdev --getsz "$DISK")"

# Alignment / sizes
START_1M=$(( 1024*1024 / SECTOR_SIZE ))
ESP_BYTES=$(( 1024*1024*1024 ))  # 1024MiB
ESP_SECTORS=$(( ESP_BYTES / SECTOR_SIZE ))

END_RESERVE_1M=$(( 1024*1024 / SECTOR_SIZE )) # keep ~1MiB free at end for safety

P1_START="$START_1M"
P1_SIZE="$ESP_SECTORS"

P2_START=$(( P1_START + P1_SIZE ))

BACKUP_SECTORS=0
if (( BACKUP_GB > 0 )); then
  BACKUP_BYTES=$(( BACKUP_GB * 1024*1024*1024 ))
  BACKUP_SECTORS=$(( BACKUP_BYTES / SECTOR_SIZE ))
fi

P2_SIZE=$(( TOTAL_SECTORS - P2_START - BACKUP_SECTORS - END_RESERVE_1M ))
if (( P2_SIZE <= 0 )); then
  echo "Not enough space for requested layout (disk too small or backup too large)." >&2
  exit 1
fi

P3_START=$(( P2_START + P2_SIZE ))

# GPT type GUIDs
ESP_GUID="C12A7328-F81F-11D2-BA4B-00A0C93EC93B"  # EFI System Partition
LINUX_GUID="0FC63DAF-8483-4772-8E79-3D69D8477DE4" # Linux filesystem

# Partition with sfdisk (GPT)
if (( BACKUP_GB > 0 )); then
  sfdisk --wipe always --wipe-partitions always --label gpt "$DISK" <<EOF
start=$P1_START, size=$P1_SIZE,  type=$ESP_GUID,  name="ESP"
start=$P2_START, size=$P2_SIZE,  type=$LINUX_GUID, name="root"
start=$P3_START, size=$BACKUP_SECTORS, type=$LINUX_GUID, name="backup"
EOF
else
  sfdisk --wipe always --wipe-partitions always --label gpt "$DISK" <<EOF
start=$P1_START, size=$P1_SIZE,  type=$ESP_GUID,  name="ESP"
start=$P2_START, size=$P2_SIZE,  type=$LINUX_GUID, name="root"
EOF
fi

partprobe "$DISK" || true
udevadm settle

ESP_DEV="$(partpath 1)"
ROOT_DEV="$(partpath 2)"
BACKUP_DEV=""
if (( BACKUP_GB > 0 )); then
  BACKUP_DEV="$(partpath 3)"
fi

# Format
mkfs.fat -F32 -n ESP "$ESP_DEV"
mkfs.ext4 -F -L root "$ROOT_DEV"
if [[ -n "$BACKUP_DEV" ]]; then
  mkfs.ext4 -F -L backup "$BACKUP_DEV"
fi

# Mount
mount "$ROOT_DEV" /mnt
mount --mkdir "$ESP_DEV" /mnt/boot
