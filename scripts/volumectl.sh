#!/usr/bin/env bash
#                __                               __   __
#   ___  ______ |  |  __ __  _____   ____   _____/  |_|  |
#   \  \/ /  _ \|  | |  |  \/     \_/ __ \_/ ___\   __\  |
#    \   (  <_> )  |_|  |  /  Y Y  \  ___/\  \___|  | |  |__
#     \_/ \____/|____/____/|__|_|  /\___  >\___  >__| |____/
#                                \/     \/     \/

#!!:/usr/bin/volumectl

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Control main sink volume & notify changes
# Dependencies : pulseaudio, dunstify

# Manage Parameters
case "$1" in
    "")
        printf "Missing argument - "
        ;&
    -h|--help)
        printf "usage: $(basename $0) [tog/dec/inc/get]\n"
        exit 0
        ;;
    tog)
        pactl set-sink-mute 0 toggle
        ;;
    dec)
        pactl set-sink-volume 0 -10%
        ;;
    inc)
        pactl set-sink-volume 0 +10%
        ;;
    get)
        ;;
    *)
        (>&2 echo "Unknown command: $1")
        exit 1
        ;;
esac

# Get State of Main Audio Sink
vol_current=$(pactl list sinks | grep '^\s*Volume' | awk '{print $5}' | sed s/%//g)
vol_muted=$(pactl list sinks | grep Mute | awk '{print $2}')

function is_muted
{
    test "$vol_muted" = 'yes'
}

# Build Volume Bar
if is_muted; then
    fill_type="▧ "
else
    fill_type="■ "
fi

# First 100% - ■ ▦ ▣ ▧ □
for (( i = 10; i <= 100; i += 10 )); do
    if [[ $i -le $vol_current ]]; then
        vol_bar+="$fill_type"
    else
        vol_bar+="□ "
    fi
done

# Amplified Beyond 100%
if [[ $vol_current -gt 100 ]]; then
    vol_bar+="| "
    for (( i = 110; i <= 150; i += 10 )); do
        if [[ $i -le $vol_current ]]; then
            vol_bar+="$fill_type"
        else
            vol_bar+="□ "
        fi
    done
fi

# Forward to Notification Daemon
is_muted && vol_status="Muted" || vol_status="${vol_current}%"
dunstify "Volume Control [$vol_status]" "$vol_bar" -t 3000 -r 30171
