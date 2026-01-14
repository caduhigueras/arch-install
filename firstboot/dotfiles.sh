#!/usr/bin/env bash

git clone https://github.com/caduhigueras/arch-dotfiles.git ~/.local/share/arch-dotfiles/

cd "$HOME/.local/share/arch-dotfiles/config/.config/themes/tokyo-night/wallpapers"
unzip wallpapers.zip
rm wallpapers.zip

cd "$HOME/.local/share/arch-dotfiles/"

rm -rf ~/.config/hypr

stow -t "$HOME" config
stow -t "$HOME" applications
sudo stow -t /usr/local/bin bin


