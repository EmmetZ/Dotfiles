#!/bin/bash
# Toggle dim inactive window

SCRIPTSDIR="$HOME/.config/hypr/scripts"

HYPRDIM=$(hyprctl getoption decoration:dim_inactive | awk 'NR==1{print $2}')

if [ "$HYPRDIM" = 1 ] ; then
    hyprctl keyword decoration:dim_inactive 0
    notify-send -u low "dim disabled"
    exit
else
    hyprctl keyword decoration:dim_inactive 1
    notify-send -u low "dim enabled"
fi
hyprctl reload
