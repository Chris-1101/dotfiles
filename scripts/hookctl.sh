#!/usr/bin/env bash

#   d8b                         d8b                          d8b
#    ?88                         ?88                 d8P    88P
#     88b                         88b             d888888P d88
#     888888b   d8888b   d8888b   888  d88' d8888b  ?88'   888
#     88P `?8b d8P' ?88 d8P' ?88  888bd8P' d8P' `P  88P    ?88
#    d88   88P 88b  d88 88b  d88 d88888b   88b      88b    88b
#   d88'   88b `?8888P' `?8888P'd88' `?88b,`?888P'  `?8b    88b

# ~/.local/bin/hookctl

# Author       : Chris-1101 @ GitHub
# Description  : Central control script for programme and system hooks
# Dependencies : polybar, polybar-msg, xrandr

# ===================
# --- Environment ---
# ===================

# Access to Graphical Environment
export DISPLAY=:0
export XAUTHORITY=$HOME/.Xauthority
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID/bus"

# =========================
# --- Polybar Functions ---
# =========================

# Check Active Displays
function has_multiple_active_displays
{
  local -ir num_monitors=$(xrandr --listactivemonitors | grep 'Monitors:' |  cut -d ' ' -f2)

  test $num_monitors -gt 1
}

# Find External Display
function get_first_external_display
{
  # Assumes single external display
  local -ar displays=($(xrandr --query | grep -e '\sconnected' | grep -v 'primary' | cut -d ' ' -f1))
  printf "${displays[0]}"
}

# Find Active Display
function get_first_active_display
{
  local -ar displays=($(xrandr --query | grep -e '\sconnected' | cut -d ' ' -f1))
  printf "${displays[0]}"
}

# Send Update to Polybar IPC Queue
function send_polybar_update
{
  local -r bar=$1
  local -r module=$2
  local -r display=$3

  local -r event='hook'
  local -i hook_no=$4

  [[ $hook_no -eq 0 ]] && hook_no=1

  local -r bar_ipc=$(readlink /tmp/polybar_${bar}_${display}.ipc)
  local -ir bar_pid=${bar_ipc##*.}

  polybar-msg -p $bar_pid "$event" "$module" $hook_no
}

# Trigger Polybar Hook
function trigger_polybar_hook
{
  local -r bar=$1
  local -r module=$2
  local -r hook=$3

  if has_multiple_active_displays; then
    send_polybar_update "$bar" "$module" 'eDP-1' "$hook"
    sleep .01 && \
    send_polybar_update "$bar" "$module" "$(get_first_external_display)" "$hook"
  else
    send_polybar_update "$bar" "$module" "$(get_first_active_display)" "$hook"
  fi
}

# =================
# --- Execution ---
# =================

case "$1" in
  -p | --polybar ) shift && trigger_polybar_hook $@ ;;
esac
