#!/usr/bin/env bash
#                         d8b         d8b
#                        88P           ?88
#                       d88             88b
#   ?88,.d88b,  d8888b  888 ?88   d8P   888888b   d888b8b    88bd88b
#   `?88'  ?88 d8P' ?88 ?88 d88   88    88P `?8b d8P' ?88    88P'  `
#     88b  d8P 88b  d88 88b ?8(  d88   d88,  d88 88b  ,88b  d88
#     888888P' `?8888P'  88b`?88P'?8b d88'`?88P' `?88P'`88bd88'
#     88P'                         )88
#    d88                          ,d8P    Launch Script
#   ?8P                        `?888P'

# ~/.config/polybar/launch.sh

# Author       : Chris-1101 @ GitHub
# Description  : Launches all polybar configurations with logs and IPC support
# Dependencies : pgrep, polybar, polybar-msg

# =================
# --- Functions ---
# =================

# Check for Running Polybar Processes
function has_processes
{
  pgrep -u $UID -x polybar > /dev/null
}

# Detect External Displays
function has_multiple_displays
{
  local -i num_displays=$(xrandr --listactivemonitors | grep 'Monitors:' |  cut -d ' ' -f2)
  test $num_displays -gt 1
}

# Find External Display
function get_first_external_display
{
  local -ar displays=($(xrandr --query | grep -e '\sconnected' | grep -v 'primary' | cut -d ' ' -f1))
  printf "${displays[0]}"
}

# Find Active Display
function get_first_active_display
{
  local -ar displays=($(xrandr --query | grep -e '\sconnected' | cut -d ' ' -f1))
  printf "${displays[0]}"
}

# Launch Polybar Configuration With Logs & IPC Support
function launch_bar_on_display
{
  local log_file="/tmp/polybar_${1}_$2.log"

  printf -- "--- $(date)\n" >> $log_file
  MONITOR="$2" polybar $1 >> $log_file 2>&1 & disown
  ln -sf /tmp/polybar_mqueue.$! /tmp/polybar_${1}_$2.ipc
}

# =================
# --- Execution ---
# =================

# Quit IPC Bars Cleanly
polybar-msg cmd quit

# Terminate Any Remaining Bars
has_processes && killall -q polybar

# Pause Until Done
while has_processes; do sleep 1; done

# Launch Bars
if has_multiple_displays; then
  launch_bar_on_display 'top' 'eDP-1'
  launch_bar_on_display 'bottom' 'eDP-1'
  launch_bar_on_display 'top' "$(get_first_external_display)"
  launch_bar_on_display 'bottom' "$(get_first_external_display)"
else
  launch_bar_on_display 'top' "$(get_first_active_display)"
  launch_bar_on_display 'bottom' "$(get_first_active_display)"
fi
