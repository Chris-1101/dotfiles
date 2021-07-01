#!/usr/bin/env bash
#                               d8P                         d8P
#                            d888888P                    d888888P
#    .d888b,?88   d8P  .d888b, ?88'  d8888b  88bd8b,d88b   ?88'    88bd88b d888b8b  ?88   d8P
#    ?8b,   d88   88   ?8b,    88P  d8b_,dP  88P'`?8P'?8b  88P     88P'  `d8P' ?88  d88   88
#      `?8b ?8(  d88     `?8b  88b  88b     d88  d88  88P  88b    d88     88b  ,88b ?8(  d88
#   `?888P' `?88P'?8b `?888P'  `?8b `?888P'd88' d88'  88b  `?8b  d88'     `?88P'`88b`?88P'?8b
#                  )88                                                                     )88
#                 ,d8P    Polybar Module                                                  ,d8P
#              `?888P'                                                                 `?888P'

# ~/.config/polybar/system_tray.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays toggle handle for system tray (stalonetray)
# Dependencies : pgrep

# =================
# --- Functions ---
# =================

# Retrieve Process ID
function get_pid_for_process
{
  pgrep -u $UID -x "$1"
}

# =================
# --- Execution ---
# =================

# StaloneTray Process ID
declare -r stalonetray_pid=$(get_pid_for_process 'stalonetray')

# Label
if [[ -z $stalonetray_pid ]]; then
  output="%{T4}%{T-} "
else
  output="%{T4}%{T-} "
fi

# Output
echo "$output"
