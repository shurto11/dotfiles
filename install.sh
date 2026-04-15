#!/bin/bash
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ~/.dotfiles 以外の場所にある場合は移動する
if [ "$DOTFILES_DIR" != "$HOME/.dotfiles" ]; then
    mv "$DOTFILES_DIR" "$HOME/.dotfiles"
    DOTFILES_DIR="$HOME/.dotfiles"
fi

sudo apt install -y stow

# 既存ファイルをバックアップして削除（stowのコンフリクト回避）
for file in $(stow --simulate -d "$DOTFILES_DIR" -t "$HOME" home 2>&1 | grep "existing target" | awk '{print $NF}'); do
    echo "backing up ~/$file"
    mv "$HOME/$file" "$HOME/$file.bak"
done

cd "$DOTFILES_DIR"
stow home
