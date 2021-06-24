#!/usr/bin/env bash

#               ,d8888b       d8b                 d8,
#               88P'         88P                  `8P
#            d888888P       d88
#     88bd88b  ?88'     d888888   d8888b ?88   d8P 88b  d8888b  d8888b .d888b,
#     88P'  `  88P     d8P' ?88  d8b_,dP d88  d8P' 88P d8P' `P d8b_,dP ?8b,
#    d88      d88      88b  ,88b 88b     ?8b ,88' d88  88b     88b       `?8b
#   d88'     d88'      `?88P'`88b`?888P' `?888P' d88'  `?888P' `?888P'`?888P'

# ~/.config/polybar/rfdevices.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays status of all radio devices (airplane mode)
# Dependencies : rfkill

# ===============
# --- Options ---
# ===============

typeset -r icon_active=''
typeset -r icon_inactive=''
typeset -r colour_inactive='#D1267F'
typeset -r colour_active='#05ADFF'

# =================
# --- Functions ---
# =================

# Check Radio State
function has_active_rf
{
  rfkill -no SOFT | grep -q 'unblocked'
}

# Icon Colour
function get_rfstate
{
  if has_active_rf; then
    printf 'active'
  else
    printf 'inactive'
  fi
}

# =================
# --- Execution ---
# =================

# Build Output
typeset -n icon="icon_$(get_rfstate)"
typeset -n colour="colour_$(get_rfstate)"
has_active_rf || typeset -r mode='%%{T5}    Airplane Mode%%{T-}'

# Output
printf "%%{F$colour}%%{T4}$icon%%{T-}$mode%%{F-}"
