#!/usr/bin/env bash

#          d8b d8,                   d8b          d8b                                      d8b
#         88P  `8P                    ?88        88P                 middle mouse button    ?88
#        d88                           88b      d88                                          88b
#    d888888    88b .d888b, d888b8b    888888b  888  d8888b      88bd8b,d88b   88bd8b,d88b   888888b
#   d8P' ?88    88P ?8b,   d8P' ?88    88P `?8b ?88 d8b_,dP      88P'`?8P'?8b  88P'`?8P'?8b  88P `?8b
#   88b  ,88b  d88    `?8b 88b  ,88b  d88,  d88 88b 88b         d88  d88  88P d88  d88  88P d88,  d88
#   `?88P'`88bd88' `?888P' `?88P'`88bd88'`?88P'  88b`?888P'    d88' d88'  88bd88' d88'  88bd88'`?88P'

# ~/.local/bin/disable-mmb

# Author       : Chris-1101 @ GitHub
# Description  : Disable middle mouse button emulation on touchpad
# Dependencies : xinput

# =================
# --- Functions ---
# =================

# Get Touchpad ID
function get_device_id
{
  xinput list | grep 'Touchpad' | grep -oP '(?<=id=)\d+'
}

# Get Touchpad Button Map
function get_button_map
{
  local -i tid=$(get_device_id)
  xinput get-button-map $tid
}

# Remap MMB => LB
function disable_mmb
{
  local -i tid=$(get_device_id)
  local -a button_map=($(get_button_map))
  button_map[1]='1' # Remap MMB to LMB

  xinput set-button-map $tid ${button_map[@]}
}

# =================
# --- Execution ---
# =================

disable_mmb
