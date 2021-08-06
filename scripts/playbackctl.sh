#!/usr/bin/env bash

#                d8b                   d8b                         d8b                         d8b
#               88P                     ?88                         ?88                 d8P   88P
#              d88                       88b                         88b             d888888Pd88
#   ?88,.d88b, 888  d888b8b  ?88   d8P   888888b   d888b8b   d8888b  888  d88' d8888b  ?88'  888
#   `?88'  ?88 ?88 d8P' ?88  d88   88    88P `?8b d8P' ?88  d8P' `P  888bd8P' d8P' `P  88P   ?88
#     88b  d8P 88b 88b  ,88b ?8(  d88   d88,  d88 88b  ,88b 88b     d88888b   88b      88b   88b
#     888888P'  88b`?88P'`88b`?88P'?8b d88'`?88P' `?88P'`88b`?888P'd88' `?88b,`?888P'  `?8b   88b
#     88P'                          )88
#    d88                           ,d8P
#   ?8P                         `?888P'

# ~/.local/bin/playbackctl

# Author       : Chris-1101 @ GitHub
# Description  : System-wide media playback toggle with notifications
# Dependencies : dunst, dunstify, playerctl

# ===============
# --- Options ---
# ===============

# Notification Icons
typeset -r Paused='~/Pictures/Icons/pause.png'
typeset -r Playing='~/Pictures/Icons/play.png'

# =================
# --- Functions ---
# =================

# Notifications
function notify
{
  local urgency='low'
  local header='Playback Control'
  local -n icon=$(get_status)
  local -i id=20381

  if [[ $icon = $Paused ]]; then
    local msg='Playback paused'
  else
    local msg='Playback resumed'
  fi

  dunstify -u "$urgency" "$header" "$msg" -i "$icon" -r $id
}

# Get Player Status
function get_status
{
  playerctl status 2>&1
}

# Check for Active Players
function has_players
{
  ! test "$(get_status)" = 'No players found'
}

# Toggle Player
function toggle_player
{
  playerctl play-pause
}

# =================
# --- Execution ---
# =================

if has_players; then
  toggle_player
  sleep 0.1
  notify
fi
