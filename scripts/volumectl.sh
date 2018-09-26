#!/usr/bin/env bash
#                __                               __   __
#   ___  ______ |  |  __ __  _____   ____  ______/  |_|  |
#   \  \/ /  _ \|  | |  |  \/     \ / __ \/  ___\   __\  |
#    \   (  (_) )  |_|  |  /  Y Y  \  ___/\  \___|  | |  |__
#     \_/ \____/|____/____/|__|_|  /\___  >\___  >__| |____/
#                                \/     \/     \/

# install:set type=root path=/usr/bin/volumectl

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Control main sink volume & notify changes
# Dependencies : pulseaudio, dunstify

# ======================
# ------- 𝘾𝙤𝙣𝙛𝙞𝙜 -------
# ======================
# Symbols used to build the notification bar
symbol_active="■"
symbol_muted="▧"
symbol_empty="□"

# Maximum volume (endless amplification can be damaging to speakers)
vol_max=150

# ===========================
# ------- 𝙑𝙤𝙡𝙪𝙢𝙚 𝘽𝙖𝙧 -------
# ===========================
function is_muted
{
  test "$vol_muted" = 'yes'
}

function get_vol
{
  pactl list sinks | grep '^\s*Volume' | awk '{print $5}' | sed s/%//g
}

function display_notification
{
  local vol_current=$(get_vol)
  local vol_muted=$(pactl list sinks | grep Mute | awk '{print $2}')

  # Build Volume Bar
  if is_muted; then
    fill_type="$symbol_muted "
  else
    fill_type="$symbol_active "
  fi

  # First 100% - ■ ▦ ▣ ▧ □
  for (( i = 10; i <= 100; i += 10 )); do
    if [[ $i -le $vol_current ]]; then
      vol_bar+="$fill_type"
    else
      vol_bar+="$symbol_empty "
    fi
  done

  # Amplified Beyond 100%
  if [[ $vol_current -gt 100 ]]; then
    vol_bar+="| "
    for (( i = 110; i <= 150; i += 10 )); do
      if [[ $i -le $vol_current ]]; then
        vol_bar+="$fill_type"
      else
        vol_bar+="$symbol_empty "
      fi
    done
  fi

  # Forward to Notification Daemon
  is_muted && vol_status="Muted" || vol_status="${vol_current}%"
  dunstify "Volume Control [$vol_status]" "$vol_bar" -t 3000 -r 30171
}

# =======================================
# ------- 𝙋𝙖𝙧𝙖𝙢𝙚𝙩𝙚𝙧 𝙈𝙖𝙣𝙖𝙜𝙚𝙢𝙚𝙣𝙩 -------
# =======================================
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
    pactl set-sink-mute 0 false
    pactl set-sink-volume 0 -10%
    ;;
  inc)
    pactl set-sink-mute 0 false
    if [[ $(get_vol) -ge $vol_max ]]; then
      pactl set-sink-volume 0 150%
    else
      pactl set-sink-volume 0 +10%
    fi
    ;;
  get)
    ;;
  *)
    (>&2 echo "Unknown command: $1")
    exit 1
    ;;
esac

# Run Main Script
display_notification
