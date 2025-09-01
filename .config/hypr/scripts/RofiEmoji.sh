#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# Variables
rofi_theme="$HOME/.config/rofi/config-emoji.rasi"
msg='<small>👀 Click or Return to choose || Ctrl V to Paste</small>'

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi


cat "$HOME/.config/hypr/scripts/emojis.txt" | \
awk '{printf "%s\0meta\x1f %s\n", $1, $2}' "$HOME/.config/hypr/scripts/emojis.txt" | \
rofi -i -dmenu -mesg "$msg" -config $rofi_theme | \
awk '{print $1}' | \
head -n 1 | \
tr -d '\n' | \
wl-copy

exit
