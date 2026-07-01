#!/bin/sh
# Script to handle audio sink control.
# Usage: asinkctl.sh {SINK|SOURCE} {up|down|mute}
# Example: audioctl.sh SINK up

case "$2" in
    "up")
        [ "$(wpctl get-volume @DEFAULT_AUDIO_"${1}"@ | awk '{print $2 * 100}')" -eq 100 ] && exit 0
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_"${1}"@ 4%+
        notify-send \
            --transient \
            -t 1000 \
            -a "mako-osd" \
            -r 9999 \
            -h string:x-canonical-private-synchronous:volume \
            -h int:value:"$(wpctl get-volume @DEFAULT_AUDIO_"${1}"@ | awk '{print $2 * 100}')" \
            "Volume"
        ;;
    "down")
        [ "$(wpctl get-volume @DEFAULT_AUDIO_"${1}"@ | awk '{print $2 * 100}')" -eq 0 ] && exit 0
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_"${1}"@ 4%-
        notify-send \
            -e \
            -t 1000 \
            -a "mako-osd" \
            -r 9999 \
            -h string:x-canonical-private-synchronous:volume \
            -h int:value:"$(wpctl get-volume @DEFAULT_AUDIO_"${1}"@ | awk '{print $2 * 100}')" \
            "Volume"
        ;;
    "mute")
        [ "$1" = "SINK" ] && _asrc="Audio" || _asrc="Microphone"
        wpctl set-mute @DEFAULT_AUDIO_"${1}"@ toggle
        notify-send \
            -e \
            -t 1000 \
            -a "mako-osd" \
            -r 9999 \
            -h string:x-canonical-private-synchronous:volume \
            "$_asrc" \
            "$(wpctl get-volume @DEFAULT_AUDIO_"${1}"@ | grep -q '[MUTED]' && echo 'Muted' || echo 'Active')"
        ;;
esac
