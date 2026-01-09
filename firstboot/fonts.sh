#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols-mono ttf-font-awesome

sudo cp "/$HOME/.local/share/arch-dotfiles/config/.config/waybar/resources/fonts/kr-icons.ttf" /usr/share/fonts/

#TODO: separate all common pths eg dotfiles into a single var
fc-cache -fv
