#!/usr/bin/env bash

git clone https://github.com/caduhigueras/arch-dotfiles ~/.local/share/arch-dotfiles/

cd ~/.local/share/arch-dotfiles/

stow -t "$HOME" config
stow -t "$HOME" applications
sudo stow -t /usr/local/bin bin

