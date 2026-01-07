#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm lua lua-dkjson lua51-dkjson
sudo ln -s /usr/share/lua/ /usr/local/share
yay -S --needed --noconfirm elephant elephant-desktopapplications elephant-menus elephant-websearch elephant-clipboard elephant-archlinuxpkgs
elephant service enable

