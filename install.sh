#!/bin/bash

# 定义要复制的 dotfiles 和文件夹
dotfiles=(.bashrc .condarc .gitconfig .gtkrc-2.0 .p10k.zsh .zshrc)
directories=(ags gtk-3.0 gtk-4.0 hypr nvim ranger rofi swaync wallust waybar wlogout fastfetch)

# 删除原来位置的 dotfiles
for file in "${dotfiles[@]}"; do
  rm ~/$file
done

# 删除原来位置的文件夹
for dir in "${directories[@]}"; do
  rm -r ~/.config/$dir
done

# 复制 dotfiles 到用户主目录
for file in "${dotfiles[@]}"; do
  cp ~/Dotfiles/$file ~/
done

# 复制文件夹到 ~/.config 目录
for dir in "${directories[@]}"; do
  cp -r ~/Dotfiles/$dir ~/.config/
done