#!/usr/bin/env bash
#                                   d8b                                   d8b
#      d8P                           ?88                                 88P
#   d888888P                          88b                               d88
#     ?88'  d8888b  ?88   d8P d8888b  888888b ?88,.d88b,  d888b8b   d888888
#     88P  d8P' ?88 d88   88 d8P' `P  88P `?8b`?88'  ?88 d8P' ?88  d8P' ?88
#     88b  88b  d88 ?8(  d88 88b     d88   88P  88b  d8P 88b  ,88b 88b  ,88b
#     `?8b `?8888P' `?88P'?8b`?888P'd88'   88b  888888P' `?88P'`88b`?88P'`88b
#                                               88P'
#                                              d88
#   ~/.config/polybar/touchpad.sh             ?8P

# Author       : Chris-1101 @ GitHub
# Description  : Displays touchpad status
# Dependencies : - N/A

# ===============
# --- Options ---
# ===============

typeset -r icon='ﳶ'
typeset -r colour_active='#00DA90'
typeset -r colour_inactive='#FFB52A'

# =================
# --- Functions ---
# =================

# Get Touchpad Info
function get_device_id
{
  xinput list | grep 'Touchpad' | grep -oP '(?<=id=)\d+'
}

# Device State
function is_enabled
{
  local touchpad_id=$(get_device_id)
  xinput list-props $touchpad_id | grep 'Device Enabled' | cut -f 3 | grep -q 1
}

# Get State
function get_state
{
  if is_enabled; then
    printf 'active'
  else
    printf 'inactive'
  fi
}

# =================
# --- Execution ---
# =================

# Build Output
typeset -n colour="colour_$(get_state)"
is_enabled || typeset -r mode='%%{T9}   Disabled%%{T-}'

# Output
printf "%%{F$colour}%%{T2}$icon%%{T-}%%{F-}$mode"
