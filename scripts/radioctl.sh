#!/usr/bin/env bash

#                             d8b d8,                            d8b
#                            88P  `8P                    d8P    88P
#                           d88                       d888888P d88
#     88bd88b d888b8b   d888888    88b d8888b   d8888b  ?88'   888
#     88P'  `d8P' ?88  d8P' ?88    88Pd8P' ?88 d8P' `P  88P    ?88
#    d88     88b  ,88b 88b  ,88b  d88 88b  d88 88b      88b    88b
#   d88'     `?88P'`88b`?88P'`88bd88' `?8888P' `?888P'  `?8b    88b

# ~/.local/bin/radioctl

# Author       : Chris-1101 @ GitHub
# Description  : Toggles software blocks on all radio devices (Bluetooth/WiFi)
# Dependencies : dunst, dunstify, rfkill

# ===============
# --- Options ---
# ===============

typeset -r config="$HOME/.config/rfstate"

# =================
# --- Functions ---
# =================

# Notifications
function notify
{
  local urgency='normal'
  local header='Radio Control'
  local -i id=12923

  has_active && local state='off' || local state='on'
  local icon="~/Pictures/Icons/airplane-$state.png"

  dunstify -u "$urgency" "$header" "Airplane mode $state" -i "$icon" -r $id
}

# Get Radio State
function get_rfstate
{
  rfkill -no SOFT
}

# Check Radio State
function has_active
{
  get_rfstate | grep -q 'unblocked'
}

# Save Radio State
function save_rfstate
{
  has_active && get_rfstate > $config
}

# Load Radio State
function load_rfstate
{
  cat $config
}

# Restore Radio State
function restore_rfstate
{
  local -a states=($(load_rfstate | sed 's/ed//g'))

  rfkill ${states[0]} bluetooth
  rfkill ${states[1]} wlan
}

# Airplane Mode
function block_rfdevices
{
  save_rfstate
  rfkill block all
}

# =================
# --- Execution ---
# =================

# Parameters
case "$1" in
  -b | --block) block_rfdevices ;;
  -u | --unblock) restore_rfstate ;;
  -t | --toggle) has_active && block_rfdevices || restore_rfstate ;;

  *) exit 1 ;;
esac

# Notify
notify
