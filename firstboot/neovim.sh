#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed neovim
# Delete old files if exist
rm -rf ~/.config/nvim/
rm -rf ~/.local/share/nvim/
rm -rf ~/.local/state/nvim/
rm -rf ~/.cache/nvim/

# Clone nvim config from git
git clone https://github.com/caduhigueras/nvim2.conf.git /home/arch/.config/nvim
