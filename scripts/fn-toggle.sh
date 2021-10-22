#!/usr/bin/env bash

#      ,d8888b                                                   d8b
#      88P'                   d8P                               88P
#   d888888P               d888888P                            d88
#     ?88'  88bd88b          ?88'  d8888b   d888b8b   d888b8b  888    d8888b
#     88P   88P' ?8b  d888P  88P  d8P' ?88 d8P' ?88  d8P' ?88  ?88   d8b_,dP
#    d88   d88   88P         88b  88b  d88 88b  ,88b 88b  ,88b  88b  88b
#   d88'  d88'   88b         `?8b `?8888P' `?88P'`88b`?88P'`88b  88b `?888P'
#                                                 )88       )88
#                                                ,88P      ,88P
#   ~/.local/bin/fn-toggle                   `?8888P   `?8888P

# Author       : Chris-1101 @ GitHub
# Description  : Rebuilds i3's config swapping specific keybinds to emulate Fn lock
# Dependencies : dunst, dunstify, i3, i3-msg, polybar, polybar-msg

# =============
# --- Paths ---
# =============

typeset -r config="$HOME/.config/i3/config"            # i3 Config
typeset -r i3_gaps="$HOME/.config/i3/i3-gaps.conf"     # Partial: Main Configuration
typeset -r fn_binds="$HOME/.config/i3/fn-binds.conf"   # Partial: Fn-Lock Keybinds

# =================
# --- Functions ---
# =================

# Notifications
function notify
{
  local urgency='low'
  local header='Fn Toggle'
  local icon='~/Pictures/Icons/keyboard.png'
  local -i id=38531

  dunstify -u "$urgency" "$header" "$1" -i "$icon" -r $id
}

# Check Fn Status
function is_enabled
{
  local -r modeline='fn_lock:set'
  local -r look_behind='(?<=status=)\w+'

  tail -n 5 $config | grep $modeline | grep -oP $look_behind | grep -q 'enabled'
}

# Reload i3 Config
function reload_i3
{
  i3-msg reload > /dev/null
}

# Trigger Polybar Hook
function trigger_polybar_hook
{
  ~/.local/bin/hookctl --polybar 'top' 'fn-status'
}

# =================
# --- Execution ---
# =================

# Reference Fn-Lock Config When Disabled
! is_enabled && typeset -n toggle=fn_binds

# Update Config File
cat $i3_gaps $toggle > $config

# Refresh i3
trigger_polybar_hook
reload_i3

# Notify
is_enabled && mode='Media' || mode='Function'
notify "$mode keys enabled"
