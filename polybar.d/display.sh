#!/usr/bin/env bash
#
#          d8b d8,                       d8b
#         88P  `8P                      88P
#        d88                           d88
#    d888888    88b .d888b,?88,.d88b, d88   d888b8b  ?88   d8P
#   d8P' ?88    88P ?8b,   `?88'  ?88 88(  d8P' ?88  d88   88
#   88b  ,88b  d88    `?8b   88b  d8P 88b  88b  ,88b ?8(  d88
#   `?88P'`88bd88' `?888P'   888888P' `88b `?88P'`88b`?88P'?8b
#                            88P'                          )88
#                           d88                           ,d8P
#                          ?8P                        `?888P'

# ~/.config/polybar/display.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays monitor status
# Dependencies : awk, bluetoothctl, rfkill

# ===============
# --- Options ---
# ===============

# Shell Options
set -o errexit    # Exit on errors
set -o pipefail   # Fail pipeline on errors
set -o nounset    # Exit on unset variables

readonly colour='#05ADFF'
readonly icon_multiple=''
readonly icon_single=''

# =================
# --- Functions ---
# =================

function has_multiple_active_displays
{
  local -ir num_monitors=$(xrandr --listactivemonitors | grep 'Monitors:' |  cut -d ' ' -f2)

  test $num_monitors -gt 1
}

function get_icon
{
  local -n icon

  has_multiple_active_displays && icon='icon_multiple' || icon='icon_single'

  printf "$icon"
}

# =================
# --- Execution ---
# =================

printf '%%{T4}%%{F%s}%s%%{F-}%%{T-}  ' "$colour" "$(get_icon)"
