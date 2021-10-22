#!/usr/bin/env bash

#      ,d8888b
#      88P'                           d8P             d8P
#   d888888P                       d888888P        d888888P
#     ?88'  88bd88b          .d888b, ?88'  d888b8b   ?88' ?88   d8P .d888b,
#     88P   88P' ?8b  d888P  ?8b,    88P  d8P' ?88   88P  d88   88  ?8b,
#    d88   d88   88P           `?8b  88b  88b  ,88b  88b  ?8(  d88    `?8b
#   d88'  d88'   88b        `?888P'  `?8b `?88P'`88b `?8b `?88P'?8b`?888P'

# ~/.config/polyar/fn-status.sh                           Polybar Module

# Author       : Chris-1101 @ GitHub
# Description  : Displays the status of the keyboard's Fn lock script
# Dependencies : none

# ===============
# --- Options ---
# ===============

typeset -r icon=''
# typeset -r colour_enabled='#FFB52A'
# typeset -r colour_enabled='#C0E0FE'
typeset -r colour_disabled='#05ADFF'
typeset -n colour_enabled='colour_disabled'

# =================
# --- Functions ---
# =================

# Check Fn Status
function is_enabled
{
  local -r config="$HOME/.config/i3/config"
  local -r modeline='fn_lock:set'
  local -r look_behind='(?<=status=)\w+'

  tail -n 5 $config | grep $modeline | grep -oP $look_behind | grep -q 'enabled'
}

# =================
# --- Execution ---
# =================

# Determine Colour
is_enabled && colour=$colour_enabled || colour=$colour_disabled
is_enabled && label='Media' || label='Function'

# Output
printf "%%{T4}%%{F$colour}$icon%%{F-}%%{T-}   %%{T9}${label% }%%{T-}"
