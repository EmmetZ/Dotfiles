#!/bin/bash
# Toggle gap between window

SCRIPTSDIR="$HOME/.config/hypr/scripts"

HAS_GAPSIN=$(hyprctl getoption general:gaps_in -j | jq .custom | sed 's/"//g' | tr ' ' '+' | bc)
HAS_GAPSOUT=$(hyprctl getoption general:gaps_out -j | jq .custom | sed 's/"//g' | tr ' ' '+' | bc)

HAS_GAPS=$(( HAS_GAPSIN + HAS_GAPSOUT ))

if [ "$HAS_GAPS" -ne 0 ]; then
    hyprctl --batch "\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword decoration:rounding 0"
    notify-send -e -u low "gap disabled"
    exit
else
    GAPSIN=$(hyprctl getoption general:gaps_in)
    GAPSOUT=$(hyprctl getoption general:gaps_out)
    ROUNDING=$(hyprctl getoption decoration:rounding)
    hyprctl --batch "\
        keyword general:gaps_in $GAPSIN;\
        keyword general:gaps_out $GAPSOUT;\
        keyword decoration:rounding $ROUNDING"
    notify-send -e -u low "gap enabled"
fi
hyprctl reload
