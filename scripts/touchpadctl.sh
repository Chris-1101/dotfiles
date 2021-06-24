#!/usr/bin/env bash

#                                   d8b                                   d8b                  d8b
#      d8P                           ?88                                 88P           d8P    88P
#   d888888P                          88b                               d88         d888888P d88
#     ?88'  d8888b  ?88   d8P d8888b  888888b ?88,.d88b,  d888b8b   d888888   d8888b  ?88'   888
#     88P  d8P' ?88 d88   88 d8P' `P  88P `?8b`?88'  ?88 d8P' ?88  d8P' ?88  d8P' `P  88P    ?88
#     88b  88b  d88 ?8(  d88 88b     d88   88P  88b  d8P 88b  ,88b 88b  ,88b 88b      88b    88b
#     `?8b `?8888P' `?88P'?8b`?888P'd88'   88b  888888P' `?88P'`88b`?88P'`88b`?888P'  `?8b    88b
#                                               88P'
#                                              d88    Touchpad Control Script
#   ~/.local/bin/touchpadctl                  ?8P

# Author       : Chris-1101 @ GitHub
# Description  : Toggles the touchpad on and off
# Dependencies : dunstify, dunst, xinput

# =================
# --- Functions ---
# =================

# Notifications
function notify
{
  local urgency='low'
  local header='Touchpad Control'
  local icon='~/Pictures/Icons/touchpad.png'
  local -i id=88453

  dunstify -u "$urgency" "$header" "$1" -i "$icon" -r $id
}

# Send Update to Polybar's IPC Queue
function trigger_polybar_hook
{
  /home/$USER/.local/bin/hookctl --polybar 'top' 'touchpad'
}

# Get Touchpad Info
function get_device_id
{
  xinput list | grep 'Touchpad' | grep -oP '(?<=id=)\d+'
}

# Touchpad State
function is_enabled
{
  xinput list-props $touchpad_id | grep 'Device Enabled' | cut -f 3 | grep -q 1
}

# Disable Touchpad
function disable_touchpad
{
  xinput --disable $touchpad_id
}

# Enable Touchpad
function enable_touchpad
{
  xinput --enable $touchpad_id
}

# =================
# --- Execution ---
# =================

# Touchpad Device ID
typeset -r touchpad_id=$(get_device_id)

# Parameters
case "$1" in
  -e | --enable) enable_touchpad ;;
  -d | --disable) disable_touchpad ;;
  -t | --toggle) is_enabled && disable_touchpad || enable_touchpad ;;

  *) exit 1 ;;
esac

# Notify & Update
trigger_polybar_hook
is_enabled && status='enabled' || status='disabled'
notify "Touchpad $status"
