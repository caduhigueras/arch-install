#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm impala bluetui wiremix btop lazygit

git clone git@github.com:caduhigueras/kr_calendar_tui.git ~/.local/share/kr-calendar-tui
cd ~/.local/share/kr-calendar-tui
cargo build --release
sudo cp target/release/kr_calendar_tui /usr/local/bin

cd /opt/arch-install
