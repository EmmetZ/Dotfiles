#!/bin/bash
# Rofi menu for Quick Edit / View of Settings (SUPER E)

# define your preferred text editor and terminal to use
editor=${EDITOR:-nano}
tty=kitty

configs="$HOME/.config/niri/configs"
root="$HOME/.config/hypr"

menu(){
  printf "1. edit default config\n"
  printf "2. edit keybinds\n"
  printf "3. edit colors\n"
  printf "4. edit inputs\n"
  printf "5. edit layout\n"
  printf "6. edit misc config\n"
  printf "7. edit outputs\n"
  printf "8. edit window rules\n"
  # printf "9. edit Plugins\n"
  # printf "10. edit hyprland.conf\n"
}

main() {
    choice=$(menu | rofi -i -dmenu -config ~/.config/rofi/config-compact.rasi | cut -d. -f1)
    case $choice in
        1)
            $tty $editor "$HOME/.config/niri/config.kdl"
            ;;
        2)
            $tty $editor "$configs/binds.kdl"
            ;;
        3)
            $tty $editor "$configs/colors.kdl"
            ;;
        4)
            $tty $editor "$configs/input.kdl"
            ;;
        5)
            $tty $editor "$configs/layout.kdl"
            ;;
        6)
            $tty $editor "$configs/misc.kdl"
            ;;
        7)
            $tty $editor "$configs/output.kdl"
            ;;
        8)
            $tty $editor "$configs/window.kdl"
            ;;
        # 9)
        #     $tty $editor "$configs/plugins.conf"
        #     ;;
        # 10)
        #     $tty $editor "$root/hyprland.conf"
        #     ;;
        *)
            ;;
    esac
}

main
