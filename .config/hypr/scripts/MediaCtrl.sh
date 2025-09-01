#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Playerctl

music_icon="$HOME/.config/swaync/icons/music.png"

# Play the next track
play_next() {
    playerctl next -i firefox
    sleep 2
    show_music_notification
}

# Play the previous track
play_previous() {
    playerctl previous -i firefox
    sleep 2
    show_music_notification
}

# Toggle play/pause
toggle_play_pause() {
    show_music_notification --invert
    playerctl play-pause -i firefox
}

# Stop playback
stop_playback() {
    playerctl stop
    notify-send -e -u low -i "$music_icon" "Playback Stopped"
}

# Display notification with song information
show_music_notification() {
    status=$(playerctl status -i firefox)
    flag=false

    if [[ "$status" == "Playing" ]]; then
        if [[ $# -eq 1 ]]; then
            flag=false
        else
            flag=true
        fi
    elif [[ "$status" == "Paused" ]]; then
        if [[ $# -eq 1 ]]; then
            flag=true
        else
            flag=false
        fi
    fi

    icon="$music_icon"

    if [[ "$flag" == true ]]; then
        song_title=$(playerctl metadata title -i firefox)
        song_artist=$(playerctl metadata artist -i firefox)
        notify-send -e -u low -i "$music_icon" "Now Playing:" "$song_title\nby $song_artist"
    elif [[ "$flag" == false ]]; then
        notify-send -e -u low -i "$music_icon" "Playback Paused"
    fi
}

# Get media control action from command line argument
case "$1" in
    "--nxt")
        play_next
        ;;
    "--prv")
        play_previous
        ;;
    "--pause")
        toggle_play_pause
        ;;
    "--stop")
        stop_playback
        ;;
    *)
        echo "Usage: $0 [--nxt|--prv|--pause|--stop]"
        exit 1
        ;;
esac
