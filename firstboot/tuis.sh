#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm impala bluetui wiremix btop lazygit ncdu yazi lazydocker
yay -S --noconfirm --needed lazysql

git clone https://github.com/caduhigueras/kr_calendar_tui.git ~/.local/share/kr-calendar-tui
cd ~/.local/share/kr-calendar-tui
cargo build --release
sudo cp target/release/kr_calendar_tui /usr/local/bin

cd /opt/arch-installer
