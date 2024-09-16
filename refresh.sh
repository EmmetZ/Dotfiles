#!/bin/bash

# 删除 Dotfiles 中所有的文件（除了 .git 文件夹和 backup.sh 文件）
cd ~/Dotfiles
find . -mindepth 1 -maxdepth 1 ! -name '.git' ! -name '*.sh' -exec rm -rf {} +

# 定义要复制的 dotfiles 和文件夹
dotfiles=(.bashrc .condarc .gitconfig .gtkrc-2.0 .p10k.zsh .zshrc)
directories=(ags gtk-3.0 gtk-4.0 hypr nvim ranger rofi swaync wallust waybar wlogout fastfetch btop kitty qt5ct qt6ct swappy Kvantum fontconfig cava)

# 将指定的 dotfiles 复制进 Dotfiles 文件夹
for file in "${dotfiles[@]}"; do
  cp ~/$file ~/Dotfiles/
done

# 将指定的文件夹复制进 Dotfiles 文件夹
for dir in "${directories[@]}"; do
  cp -r ~/.config/$dir ~/Dotfiles/
done

rm -rf ~/Dotfiles/ranger/plugins