#!/bin/bash
# Toggle dim inactive window

notif="$HOME/.config/swaync/images/bell.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

HYPRDIM=$(hyprctl getoption decoration:dim_inactive | awk 'NR==1{print $2}')

if [ "$HYPRDIM" = 1 ] ; then
    hyprctl --batch "keyword decoration:dim_inactive 0"
    notify-send -u low -i "$notif" "dim disabled"
    exit
else
    hyprctl --batch "keyword decoration:dim_inactive 1"
    notify-send -u low -i "$notif" "dim enabled"
fi
hyprctl reload
