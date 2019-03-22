#!/usr/bin/env bash
#   ___                   __    __   __        __     __          __   __
#   \_ |__ _____   _____ |  | _|  | |__| ____ |  |___/  |_ ______/  |_|  |
#    | __ \\__  \ /  ___\|  |/ /  | |  |/ ___\|  |  \   __\  ___\   __\  |
#    | \_\ \/ __ \\  \___|    <|  |_|  / /_/  >   Y  \  | \  \___|  | |  |__
#    |___  (____  /\___  >__|_ \____/__\___  /|___|  /__|  \___  >__| |____/
#        \/     \/     \/     \/      /_____/      \/          \/

# install:set type=root path=/usr/bin/backlightctl

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Control screen brightness and notify changes
# Dependencies : light, dunstify

# ======================
# ------- 𝘾𝙤𝙣𝙛𝙞𝙜 -------
# ======================
# The name of the script as it appears on notifications
script_name="Backlight Control"

# Symbols used to build the notification bar
symbol_active="■"
symbol_empty="□"

# Duration to display the notification in ms
not_duration=3000

# ID used for notifications, can be ignored
not_id=8171

# ===========================
# ------- 𝙈𝙖𝙞𝙣 𝙎𝙘𝙧𝙞𝙥𝙩 -------
# ===========================
function display_notification
{
  # Current Brightness Level
  bl_pct=$(awk '{$i = int( ($i + 2) / 5) * 5 ""} 1' <<< "$(light -G)")
  bl_val=$(( $bl_pct / 10 ))

  # Build Notification Bar - □ ▣ ■
  for (( i = 1; i <= 10; i++ )); do
    if [[ $i -le $bl_val ]]; then
      bl_bar+="$symbol_active "
    else
      bl_bar+="$symbol_empty "
    fi
  done

  # Forward to Notification Daemon
  dunstify "$script_name" "$bl_bar" -t $not_duration -r $not_id
}

# =======================================
# ------- 𝙋𝙖𝙧𝙖𝙢𝙚𝙩𝙚𝙧 𝙈𝙖𝙣𝙖𝙜𝙚𝙢𝙚𝙣𝙩 -------
# =======================================
case "$1" in
  "")
    printf "Missing argument - "
    ;&
  -h|--help)
    printf "usage: $(basename $0) [dec/inc/get]\n"
    exit 0
    ;;
  dec)
    light -U 5
    ;;
  inc)
    light -A 5
    ;;
  get)
    ;;
  *)
    (>&2 echo "Unknown command: $1")
    exit 1
    ;;
esac

display_notification
unset display_notification
