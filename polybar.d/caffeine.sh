#!/usr/bin/env bash

#                        ,d8888b ,d8888b     d8,
#                        88P'    88P'        `8P
#                     d888888Pd888888P
#    d8888b  d888b8b    ?88'    ?88'  d8888b  88b 88bd88b   d8888b
#   d8P' `P d8P' ?88    88P     88P  d8b_,dP  88P 88P' ?8b d8b_,dP
#   88b     88b  ,88b   d88     d88  88b     d88 d88   88P 88b
#   `?888P' `?88P'`88b d88'    d88'  `?888P'd88'd88'   88b `?888P'

# ~/.config/polyar/caffeine.sh                    Polybar Module

# Author       : Chris-1101 @ GitHub
# Description  : Displays the status of the caffeinectl script
# Dependencies : none

# ===============
# --- Options ---
# ===============

typeset -r colour='#C0E0FE'
typeset -r icon_enabled=''
typeset -r icon_disabled=''

# =================
# --- Functions ---
# =================

# Check Fn Status
function is_enabled
{
  pgrep -f -- '-n caffeinectl'
}

# =================
# --- Execution ---
# =================

# Determine Icon
is_enabled && icon=$icon_enabled || icon=$icon_disabled

# Output
printf "%%{T4}%%{F$colour}$icon%%{F-}%%{T-}"
