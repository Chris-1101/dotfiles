#!/usr/bin/env bash

#                        ,d8888b ,d8888b     d8,
#                        88P'    88P'        `8P
#                     d888888Pd888888P
#    d8888b  d888b8b    ?88'    ?88'  d8888b  88b 88bd88b   d8888b
#   d8P' `P d8P' ?88    88P     88P  d8b_,dP  88P 88P' ?8b d8b_,dP
#   88b     88b  ,88b   d88     d88  88b     d88 d88   88P 88b
#   `?888P' `?88P'`88b d88'    d88'  `?888P'd88'd88'   88b `?888P'

# ~/.local/bin/caffeinectl

# Author       : Chris-1101 @ GitHub
# Description  : Inhibits the screensaver using light-locker-command
# Dependencies : dunst, light-locker (LightDM), polybar

# ===============
# --- Options ---
# ===============

typeset -r script_name='caffeinectl'
typeset -r description='Keep screen alive'

# ===============
# --- Utility ---
# ===============

# Logger
source "$(dirname $0)/lib/logger.sh"

# Notifications
function notify
{
  local urgency='normal'
  local header='Caffeine'
  local icon='~/Pictures/Icons/coffee.png'
  local -i id=62471

  dunstify -u "$urgency" "$header" "$1" -i "$icon" -r $id
}

# Send Update to Polybar's IPC Queue
function trigger_polybar_hook
{
  ~/.local/bin/hookctl --polybar 'top' 'caffeine'
}

# ===================
# --- Screensaver ---
# ===================

# Status
function is_enabled
{
  pgrep -f -- "-n $script_name" > /dev/null
}

# Disable Screensaver
function inhibit_screensaver
{
  trap end_session RETURN
  notify 'Screensaver disabled'
  logger "$script_name" "Beginning caffeine session, screensaver disabled"

  sleep .1 && trigger_polybar_hook &
  light-locker-command -i -n "$script_name" -r "$description" 2>&1 >/dev/null
}

# Enable Screensaver
function resume_screensaver
{
  local -i pid=$(pgrep -f -- "-n $script_name")
  kill -SIGTERM $pid
}

# =============
# --- Traps ---
# =============

# Trap Handler
function end_session
{
  logger "$script_name" "Ending caffeine session, screensaver enabled"
  notify 'Screensaver enabled'
  trigger_polybar_hook
}

# =================
# --- Execution ---
# =================

# Params
case "$1" in
  -t | --toggle ) is_enabled && resume_screensaver || inhibit_screensaver !& ;;
  -1 | --on ) inhibit_screensaver !& ;;
  -0 | --off ) resume_screensaver ;;
esac
