#!/usr/bin/env bash

#                                        ,d8888b  d8b
#                                        88P'    88P
#                                     d888888P  d88
#    d8888b  ?88   d8P d8888b  88bd88b  ?88'    888   d8888b  ?88   d8P  d8P
#   d8P' ?88 d88  d8P'd8b_,dP  88P'  `  88P     ?88  d8P' ?88 d88  d8P' d8P'
#   88b  d88 ?8b ,88' 88b     d88      d88      88b  88b  d88 ?8b ,88b ,88'
#   `?8888P' `?888P'  `?888P'd88'     d88'       88b `?8888P' `?888P'888P'

# ~/.config/polybar/overflow.sh

# Author       : Chris-1101 @ GitHub
# Description  : Overflow menu to store infrequently used "modules"
# Dependencies : ---

# =================
# --- Execution ---
# =================

case "$1" in
  open)
    echo "%{T4}%{A1:~/.local/bin/hookctl --polybar 'top' 'overflow' 1:}%{A}%{T-}  "\
         "$(~/.config/polybar/rfdevices.sh)   "\
         "$(~/.config/polybar/microphone.sh)   "\
         "$(~/.config/polybar/touchpad.sh)"
    ;;
  close) echo "%{T4}%{A1:~/.local/bin/hookctl --polybar 'top' 'overflow' 2:}%{A}%{T-}" ;;
esac
