#!/usr/bin/env bash

git clone https://github.com/abenz1267/walker.git ~/.local/share/walker/
cd ~/.local/share/walker/

cargo build --release
sudo cp ./target/release/walker /usr/bin/


