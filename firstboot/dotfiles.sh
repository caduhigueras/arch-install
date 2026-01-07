#!/usr/bin/env bash

git clone https://github.com/caduhigueras/arch-dotfiles.git ~/.local/share/arch-dotfiles/

cd ~/.local/share/arch-dotfiles/

rm -rf ~/.config/hypr

stow -t "$HOME" config
stow -t "$HOME" applications
sudo stow -t /usr/local/bin bin


