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
# Symbols used to build the notification bar - ■ ▦ ▣ ▧ □
symbol_active="■"
symbol_muted="▧"
symbol_empty="□"
symbol_step="▣"

# Maximum volume (safeguard speakers)
vol_max=150

# =================================
# ------- 𝙑𝙤𝙡𝙪𝙢𝙚 𝙁𝙪𝙣𝙘𝙩𝙞𝙤𝙣𝙨 -------
# =================================
function validate_input
{
  if [[ $2 =~ [^0-9]+ ]]; then
    printf "Invalid argument passed to $1: ${2/%/\%}, must be integer\n"
    exit 1
  fi
}

function get_vol
{
  pactl list sinks | grep '^\s*Volume' | awk '{print $5}' | sed s/%//g
}

function unmute
{
  pactl set-sink-mute 0 false
}

function toggle_mute_state
{
  pactl set-sink-mute 0 toggle
}

function is_muted
{
  test "$vol_muted" = 'yes'
}

function increase_volume
{
  if [[ $(get_vol) -ge $vol_max ]]; then
    pactl set-sink-volume 0 150%
  else
    pactl set-sink-volume 0 +${1}%
  fi
}

function decrease_volume
{
  pactl set-sink-volume 0 -${1}%
}

# ===========================
# ------- 𝙑𝙤𝙡𝙪𝙢𝙚 𝘽𝙖𝙧 -------
# ===========================
function display_notification
{
  local vol_current=$(get_vol)
  local vol_muted=$(pactl list sinks | grep Mute | awk '{print $2}')

  # Determine Symbols Based on Muted State
  if is_muted; then
    main_fill_type="$symbol_muted"
    step_fill_type="$symbol_muted"
  else
    main_fill_type="$symbol_active"
    step_fill_type="$symbol_step"
  fi

  # Build Volume Bar
  function get_symbol
  {
    local vol_diff=$(( vol_current % 10 ))

    if [[ $1 -le $vol_current ]]; then
      echo $main_fill_type
    elif [[ $vol_diff -ne 0 && $vol_current -eq $(( $1 - $vol_diff )) ]]; then
      echo $step_fill_type
    else
      echo $symbol_empty
    fi
  }

  # First 100%
  for (( i = 10; i <= 100; i += 10 )); do
    vol_bar+="$(get_symbol $i) "
  done

  # Amplified Beyond 100%
  if [[ $vol_current -gt 100 ]]; then
    vol_bar+="| "
    for (( i = 110; i <= $vol_max; i += 10 )); do
      vol_bar+="$(get_symbol $i) "
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
    toggle_mute_state
    ;;
  dec)
    validate_input $1 $2
    unmute
    decrease_volume $2
    ;;
  inc)
    validate_input $1 $2
    unmute
    increase_volume $2
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
