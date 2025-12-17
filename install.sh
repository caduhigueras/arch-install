#!/bin/bash

# Install initial deps
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run as root (or with sudo)." >&2
  exit 1
fi

# ---- dependency install (Arch) ----
need_cmd() { command -v "$1" >/dev/null 2>&1; }

PACMAN_PKGS=(
  git
  gum
  util-linux   # sfdisk, lsblk
  parted       # partprobe (sometimes provided by util-linux too; harmless)
  e2fsprogs    # mkfs.ext4
  dosfstools   # mkfs.fat
)

# Install official repo packages (quiet download output, no prompts, only if missing)
missing_pacman=()
for p in "${PACMAN_PKGS[@]}"; do
  pacman -Q "$p" >/dev/null 2>&1 || missing_pacman+=("$p")
done

if ((${#missing_pacman[@]})); then
  pacman -Sy --noconfirm --needed --quiet "${missing_pacman[@]}"
fi

require() { command -v "$1" >/dev/null 2>&1 || { echo "Missing dependency: $1" >&2; exit 1; }; }

# Clone project
git clone https://github.com/caduhigueras/arch-install.git /root/arch-installer

cd /root/arch-installer

source ./preflight.sh
