#!/usr/bin/env bash

#               ,d8888b       d8b                 d8,
#               88P'         88P                  `8P
#            d888888P       d88
#     88bd88b  ?88'     d888888   d8888b ?88   d8P 88b  d8888b  d8888b .d888b,
#     88P'  `  88P     d8P' ?88  d8b_,dP d88  d8P' 88P d8P' `P d8b_,dP ?8b,
#    d88      d88      88b  ,88b 88b     ?8b ,88' d88  88b     88b       `?8b
#   d88'     d88'      `?88P'`88b`?888P' `?888P' d88'  `?888P' `?888P'`?888P'

# /usr/local/bin/rf-handler.sh

# Author       : Chris-1101 @ GitHub
# Description  : Updates Polybar when udev receives RF related events (Bluetooth/WiFi)
# Dependencies : polybar, polybar-msg

# =================
# --- Functions ---
# =================

# Send Update to Polybar's IPC Queue
function trigger_polybar_hook
{
  su - $(id -un 1000) -c "~/.local/bin/hookctl --polybar 'top' $1"
}

# ================
# --- Execution---
# ================

# Log to System Journal
interface="$1" && shift
systemd-cat -p info -t rf-handler <<< "Received $interface related udev event: $@"

# Delay
sleep 1

# Handler
if [[ $interface = 'bluetooth' ]]; then
  trigger_polybar_hook 'bluetooth'
else
  sleep 1
  trigger_polybar_hook 'airplane-mode'
  trigger_polybar_hook 'vpn'
fi
