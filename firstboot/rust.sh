#!/usr/bin/env bash

if ! command -v rustup >/dev/null 2>&1; then
    # Install rust toolchain
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
