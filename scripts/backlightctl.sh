#!/usr/bin/env bash
#   ___                   __    __   __        __     __          __   __
#   \_ |__ _____    ____ |  | _|  | |__| ____ |  |___/  |_  _____/  |_|  |
#    | __ \\__  \ _/ ___\|  |/ /  | |  |/ ___\|  |  \   __\/ ___\   __\  |
#    | \_\ \/ __ \\  \___|    <|  |_|  / /_/  >   Y  \  | \  \___|  | |  |__
#    |___  (____  /\___  >__|_ \____/__\___  /|___|  /__|  \___  >__| |____/
#        \/     \/     \/     \/      /_____/      \/          \/

#!!:/usr/bin/backlightctl

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Control screen brightness and notify changes
# Dependencies : light, dunstify

# Manage Parameters
case "$1" in
    "")
        printf "Missing argument - "
        ;&
    -h|--help)
        printf "usage: $(basename $0) [dec/inc/get]\n"
        exit 0
        ;;
    dec)
        light -U 10
        ;;
    inc)
        light -A 10
        ;;
    get)
        ;;
    *)
        (>&2 echo "Unknown command: $1")
        exit 1
        ;;
esac

# Determine Current Brightness Level / 10
bl_current=$(awk '{$i = int( ($i + 2) / 5) * 0.5 ""} 1' <<< "$(light -G)")

# Build Brightness Bar - □ ▣ ■
for (( i = 1; i <= 10; i++ )); do
    if [[ $i -le $bl_current ]]; then
        bl_bar+="■ "
    else
        bl_bar+="□ "
    fi
done

# Forward to Notification Daemon
dunstify "Backlight Control" "$bl_bar" -t 3000 -r 8171
unset bl_bar
