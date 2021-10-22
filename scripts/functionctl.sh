#!/usr/bin/env bash

#      ,d8888b                                 d8,                                     d8b
#      88P'     Function & Media Keys    d8P   `8P       Control Script        d8P    88P
#   d888888P                          d888888P                              d888888P d88
#     ?88' ?88   d8P   88bd88b   d8888b ?88'   88b  d8888b   88bd88b   d8888b ?88'   888
#     88P  d88   88    88P' ?8b d8P' `P 88P    88P d8P' ?88  88P' ?8b d8P' `P 88P    ?88
#    d88   ?8(  d88   d88   88P 88b     88b   d88  88b  d88 d88   88P 88b     88b    88b
#   d88'   `?88P'?8b d88'   88b `?888P' `?8b d88'  `?8888P'd88'   88b `?888P' `?8b    88b

# ~/.local/bin/functionctl

# Author       : Chris-1101 @ GitHub
# Description  : Calls media key equivalent to specified Fx key
# Dependencies : xdotool

# ==================
# --- Keys Array ---
# ==================

typeset -Ar keys=(
  ['F1']='XF86AudioMute'
  ['F2']='XF86AudioLowerVolume'
  ['F3']='XF86AudioRaiseVolume'
  ['F4']='super+p'
  ['F5']='XF86AudioPrev'
  ['F6']='XF86AudioPlay'
  ['F7']='XF86AudioNext'
  ['F8']='XF86MonBrightnessDown'
  ['F9']='XF86MonBrightnessUp'
  ['F10']='' # Unused
  ['F11']='' # Unused
  ['F12']='Print'
)

# =================
# --- Functions ---
# =================

# Caps Lock Status
# function get_caps_status
# {
#   xset q | grep 'Caps Lock:' | awk '{print $4}'
# }
#
# # Determine Key
# function get_key
# {
#   case "$(get_caps_status)" in
#     'on') echo $1 ;;
#     'off') echo ${keys[$1]} ;;
#   esac
# }

# =================
# --- Execution ---
# =================

[[ -n $2 ]] && \
typeset -r modifiers="$2+"
typeset -r key=${keys[$1]}

# Simulate Keystroke
[[ -n $key ]] && xdotool key $modifiers$key
