#!/usr/bin/env bash
#                                                                                   d8b
#                              d8P                                         d8P    88P
#                           d888888P                                    d888888P ?88
#    .d888b,?88   d8P .d888b, ?88'    88bd88b d888b8b  ?88   d8P  d8888b  ?88'   888
#    ?8b,   d88   88  ?8b,    88P     88P'  `d8P' ?88  d88   88  d8P' `P  88P    ?88
#      `?8b ?8(  d88    `?8b  88b    d88     88b  ,88b ?8(  d88  88b      88b    88b
#   `?888P' `?88P'?8b`?888P'  `?8b  d88'     `?88P'`88b`?88P'?8b `?888P'  `?8b    88b
#                  )88                                        )88
#                 ,d8P      System Tray Control Script       ,d8P
#             `?888P'                                    `?888P'

# ~/.local/bin/systrayctl

# Author       : Chris-1101 @ GitHub
# Description  : Toggles the visibility of the system tray (StaloneTray)
# Dependencies : pcregrep, pgrep, polybar, polybar-msg, stalonetray

# =================
# --- Functions ---
# =================

# Retrieve Primary Display's Horinzontal Offset
function get_horizontal_offset
{
  local -r pattern='(?:primary\s\d+x\d+\+)(\d+)(?:\+\d+)'
  pcregrep -o1 "$pattern" <<< $(xrandr --query)
}

# Retrieve StaoneTray Geometry
function get_geometry
{
  local -ir rows=10 cols=1 x=1895 y=32
  local -ir offset=$(get_horizontal_offset)

  printf "${cols}x${rows}+$(( x + offset ))-$y"
}

# Retrieve Process ID
function get_pid_for_process
{
  pgrep -u $UID -x "$1"
}

# Polybar Top Bar IPC
function trigger_polybar_hook
{
  ~/.local/bin/hookctl --polybar 'bottom' 'tray-toggle'
}

# =================
# --- Execution ---
# =================

# StaloneTray Process ID
typeset -r stalonetray_pid=$(get_pid_for_process 'stalonetray')

# Toggle
if [[ -z $stalonetray_pid ]]; then
  stalonetray --geometry "$(get_geometry)" &!
  trigger_polybar_hook
else
  kill -SIGTERM $stalonetray_pid
  trigger_polybar_hook
fi
