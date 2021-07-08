#!/usr/bin/env bash

#   d8b                         d8b           d8b   d8,           d8b                                d8b
#    ?88                         ?88         88P   `8P             ?88         d8P           d8P    88P
#     88b                         88b       ?88                     88b     d888888P      d888888P ?88
#     888888b   d888b8b   d8888b  888  d88' 888    88b  d888b8b     888888b   ?88'  d8888b  ?88'   888
#     88P `?8b d8P' ?88  d8P' `P  888bd8P'  ?88    88P d8P'  ?88    88P `?8b  88P  d8P' `P  88P    ?88
#    d88,  d88 88b  ,88b 88b     d88888b    88b   d88  88b   ,88b  d88   88P  88b  88b      88b    88b
#   d88'`?88P' `?88P'`88b`?888P'd88' `?88b,  88b d88'  `?88P'`88b d88'   88b  `?8b `?888P'  `?8b    88b
#                                                             )88
#                                                           ,88P    Backlight Brightness Control Script
# ~/.local/bin/backlightctl                             `?8888P

# Author       : Chris-1101 @ GitHub
# Description  : Controls screen backlight brightness and sends notifications
# Dependencies : dunst, dunstify, light

# ===============
# --- Options ---
# ===============

# Notification Symbols - ■ ▦ ▣ ▧ □ ▪ ▫
typeset -r symbol_full="■"
typeset -r symbol_half="▣"
typeset -r symbol_empty="□"

# ===========================
# --- Backlight Functions ---
# ===========================

# Get Brightness
function get_brightness
{
  light -G | xargs printf '%.0f'
}

# Increase Brightness
function inc_brightness
{
  light -A $1
}

# Decrease Brightness
function dec_brightness
{
  light -U $1
}

# ======================
# --- Brightness Bar ---
# ======================

# Notifications
function notify
{
  local urgency='normal'
  local header="Backlight Control             $(get_brightness)%"
  local icon='~/Pictures/Icons/sun.png'
  local -i id=30173

  dunstify -u "$urgency" "$header" "$1" -i "$icon" -r $id
}

# Build Brightness Bar
function display_brightness
{
  local -i brightness_pct=$(get_brightness)
  local -i brightness_units=$(( brightness_pct % 10 ))

  # Build Notification Bar
  for (( i = 10; i <= 100; i += 10 )); do
    if [[ $i -le $brightness_pct ]]; then
      brightness_bar+="$symbol_full "
    elif [[ $brightness_units -ne 0 && $i -lt $(( brightness_pct + 10 )) ]]; then
      brightness_bar+="$symbol_half "
    else
      brightness_bar+="$symbol_empty "
    fi
  done

  # Forward to Notification Daemon
  notify "$brightness_bar"

  # Fix Decimal Loss in Brightness Levels
  light -S $brightness_pct
}

# =================
# --- Execution ---
# =================

# Parameters
case "$1" in
  -d | --decrease) dec_brightness $2 ;;
  -i | --increase) inc_brightness $2 ;;
  -g | --get) ;;
  *) exit 1 ;;
esac

# Display Notification
display_brightness
