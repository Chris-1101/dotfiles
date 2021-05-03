#!/usr/bin/env bash

#   d8b          d8b                                               d8b
#    ?88        88P                   d8P                     d8P   ?88
#     88b      d88                 d888888P                d888888P  88b
#     888888b  888 ?88   d8P d8888b  ?88'  d8888b   d8888b   ?88'    888888b
#     88P `?8b ?88 d88   88 d8b_,dP  88P  d8P' ?88 d8P' ?88  88P     88P `?8b
#    d88,  d88 88b ?8(  d88 88b      88b  88b  d88 88b  d88  88b    d88   88P
#   d88'`?88P'  88b`?88P'?8b`?888P'  `?8b `?8888P' `?8888P'  `?8b  d88'   88b

# ~/.config/rofi/bluetooth.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays a Rofi menu to control Bluetooth devices & connectivity
# Dependencies : awk, bluetoothctl, rfkill, rofi

IFS='' # Allow spaces in array elements

# =================
# --- Functions ---
# =================

# Interface Stats
function is_enabled
{
  rfkill | grep 'bluetooth' | grep -q ' blocked'
  test $? -ne 0 # negate above command (hacky)
}

# Retrieve Paired Devices
function get_paired_devices
{
  bluetoothctl paired-devices
}

# Device Connection Status
function is_connected
{
  grep -q 'Connected: yes' <<< $(bluetoothctl info "$1")
}

# Determine Character Width of Longest Line
function get_width
{
  local markup='<span font_desc="DejaVuSansMono Nerd Font normal 12"></span>'
  local -i len_markup=${#markup}
  local -i len_raw=$(wc -L <<< $1)
  local -i len_net=$(( (len_raw - len_markup) / 2 + 1 ))
  printf $len_net
}

# =================
# --- Execution ---
# =================

# Associative Array
typeset -A devices=()

# Retrieve All Paired Devices
paired_devices=$(get_paired_devices)

# Associate Device Aliases & MAC Addresses
while read device; do
  device_address=$(awk '{print $2}' <<< "$device")
  device_name=$(awk '{for (i = 3; i <= NF; ++i) printf $i " "; print ""}' <<< "$device")
  device_name="${device_name% }" # Trim trailing spaces
  lf=$'\n'

  # Connection Status
  is_connected $device_address && icon='' || icon=''

  entries+="<span font_desc=\"DejaVuSansMono Nerd Font normal 12\">$icon</span>   $device_name$lf"
  devices[$device_name]+="$device_address"
done <<< "$paired_devices"

# Build Menu Contents
if is_enabled; then
  entries+="<span font_desc=\"DejaVuSansMono Nerd Font normal 12\"></span>   Disable"
else
  entries='<span font_desc=\"DejaVuSansMono Nerd Font normal 12\"></span>   Enable'
fi

# Launch Rofi Menu
unset IFS # Rofi won't start with a set but enpty IFS
typeset -r options="-dmenu -markup-rows -config ~/.config/rofi/bluetooth.rasi"
choice=$(printf "$entries" | rofi $options -lines `wc -l <<< "$entries"` -width `get_width "$entries"`)

# Extract Device Info
selection="${choice##*'>   '}"
device="${devices[$selection]}"

# Determine Action
if is_connected "$device"; then
  action='disconnect'
else
  action='connect'
fi

# Execute Selected Item
case "$selection" in
  ''        ) exit 0 ;; # No selection
  'Enable'  ) rfkill unblock bluetooth && bluetoothctl power on ;;
  'Disable' ) bluetoothctl power off && rfkill block bluetooth ;;

  *) bluetoothctl $action "$device" ;;
esac
