#!/bin/bash
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ~/.dotfiles 以外の場所にある場合は移動する
if [ "$DOTFILES_DIR" != "$HOME/.dotfiles" ]; then
    mv "$DOTFILES_DIR" "$HOME/.dotfiles"
    DOTFILES_DIR="$HOME/.dotfiles"
fi

sudo apt install -y stow
cd "$DOTFILES_DIR"
stow home
