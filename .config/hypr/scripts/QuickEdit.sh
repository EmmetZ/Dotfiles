#!/bin/bash
# Rofi menu for Quick Edit / View of Settings (SUPER E)

# define your preferred text editor and terminal to use
editor=${EDITOR:-nano}
tty=kitty

configs="$HOME/.config/hypr/configs"

menu(){
  printf "1. edit Default-Settings\n"
  printf "2. edit Window-Rules\n"
  printf "3. edit Startup\n"
  printf "4. edit Keybinds\n"
  printf "5. edit Monitors\n"
  printf "6. edit Decoration-Animation\n"
  printf "7. edit Env-variables\n"
  printf "8. edit Workspace-Rules\n"
  printf "9. edit Plugins\n"
}

main() {
    choice=$(menu | rofi -i -dmenu -config ~/.config/rofi/config-compact.rasi | cut -d. -f1)
    case $choice in
        1)
            $tty $editor "$configs/default.conf"
            ;;
        2)
            $tty $editor "$configs/window_rules.conf"
            ;;
        3)
            $tty $editor "$configs/startup.conf"
            ;;
        4)
            $tty $editor "$configs/keybinds.conf"
            ;;
        5)
            $tty $editor "$configs/monitors.conf"
            ;;
        6)
            $tty $editor "$configs/deco_animation.conf"
            ;;
        7)
            $tty $editor "$configs/env_variables.conf"
            ;;
        8)
            $tty $editor "$configs/workspace_rules.conf"
            ;;
        9)
            $tty $editor "$configs/plugins.conf"
            ;;
        *)
            ;;
    esac
}

main
