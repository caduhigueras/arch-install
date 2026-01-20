#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm nodejs
sudo pacman -S npm
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global

npm i -g @hubspot/cli
npm i -g typescript
