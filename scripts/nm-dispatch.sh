#!/usr/bin/env bash

#   ?88   d8P ?88,.d88b,  88bd88b
#   d88  d8P' `?88'  ?88  88P' ?8b
#   ?8b ,88'    88b  d8P d88   88P
#   `?888P'     888888P'd88'   88b
#              88P'
#             d88    Event Handler
#            ?8P

# /etc/NetworkManager/dispatcher.d/polybar-hook.sh

# Author       : Chris-1101 @ GitHub
# Description  : Updates Polybar's VPN module on connectivity change
# Dependencies : hookctl, systemd

# =================
# --- Functions ---
# =================

# Send Update to Polybar's IPC Queue
function trigger_polybar_hook
{
  su - $(id -un 1000) -c "~/.local/bin/hookctl --polybar 'top' 'vpn'"
}

# =================
# --- Execution ---
# =================

# Context
interface=$1
event=$2

# Log to System Journal
systemd-cat -p info -t nm-polybar-hook <<< "Received event [$event] from interface [$interface] :: $@"

# Handler
case "$event" in
  up|down) trigger_polybar_hook ;;
  *) exit 0 ;;
esac
