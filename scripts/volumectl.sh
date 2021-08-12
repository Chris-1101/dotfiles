#!/usr/bin/env bash
#                       d8b                                                   d8b
#                      88P                 Volume Control Script      d8P    88P
#                     d88                                          d888888P d88
#   ?88   d8P d8888b  888  ?88   d8P   88bd8b,d88b   d8888b  d8888b  ?88'   888
#   d88  d8P'd8P' ?88 ?88  d88   88    88P'`?8P'?8b d8b_,dP d8P' `P  88P    ?88
#   ?8b ,88' 88b  d88 88b  ?8(  d88   d88  d88  88P 88b     88b      88b    88b
#   `?888P'  `?8888P'  88b `?88P'?8b d88' d88'  88b `?888P' `?888P'  `?8b    88b

# ~/.local/bin/volumectl

# Author       : Chris-1101 @ GitHub
# Description  : Controls volume and sends notifications
# Dependencies : amixer, dunst, dunstify, pactl

# ===============
# --- Options ---
# ===============

# Notification Symbols - ■ ▦ ▣ ▧ □
typeset -r symbol_active='■'
typeset -r symbol_muted='▧'
typeset -r symbol_empty='□'
typeset -r symbol_step='▣'
typeset -r icon='~/Pictures/Icons/sound.png'

# Maximum Volume
typeset -r volume_max=150

# ========================
# --- Volume Functions ---
# ========================

# Get Current Volume
function get_volume
{
  amixer sget Master | grep -oE '[[:digit:]]+%' | head -n 1 | sed 's/%//g'
}

# Set Volume Level
function set_volume # -10% / +5% / 70% / etc
{
  pactl set-sink-volume @DEFAULT_SINK@ "$1"
}

# Get Mute State
function is_muted
{
  amixer sget Master | grep -q '%] \[off]'
}

# Set Mute State
function set_mute_state # 0 / 1 / toggle
{
  pactl set-sink-mute @DEFAULT_SINK@ "$1"
}

# ==================
# --- Volume Bar ---
# ==================

# Build Volume Bar
function display_volume
{
  local -i volume_pct=$(get_volume)
  local -i vol_units=$(( volume_pct % 10 ))

  # Get Fill Symbol
  function get_symbol
  {
    if [[ $1 -le $volume_pct ]]; then
      echo $symbol_full
    elif [[ $vol_units -ne 0 && $1 -lt $(( volume_pct + 10 )) ]]; then
      echo $symbol_half
    else
      echo $symbol_empty
    fi
  }

  # Symbols
  if is_muted; then
    local symbol_full=$symbol_muted
    local symbol_half=$symbol_muted
  else
    local symbol_full=$symbol_active
    local symbol_half=$symbol_step
  fi

  # First 100%
  for (( i = 10; i <= 100; i += 10 )); do
    volume_bar+="$(get_symbol $i) "
  done

  # Amplified Beyond 100%
  if [[ $volume_pct -gt 100 ]]; then
    volume_bar+="| "
    for (( i = 110; i <= $volume_max; i += 10 )); do
      volume_bar+="$(get_symbol $i) "
    done
  fi

  # Forward to Notification Daemon
  is_muted && volume_status="Muted" || volume_status="   ${volume_pct}%"
  dunstify "Volume Control             $volume_status" "$volume_bar" -i $icon -r 30171
}

# =================
# --- Execution ---
# =================

# Parameters
case "$1" in
  -d | --decrease) set_mute_state 0 && set_volume "-$2%" ;;
  -i | --increase) set_mute_state 0 && set_volume "+$2%" ;;
  -t | --toggle) set_mute_state toggle ;;
  -g | --get) ;;
  *) exit 1 ;;
esac

# Safeguard
[[ $(get_volume) -gt $volume_max ]] && set_volume "$volume_max%"

# Display Volume
display_volume
