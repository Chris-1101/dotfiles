#!/usr/bin/env bash

#   d8b          d8b                                                 d8b
#    ?88        88P      Polybar        d8P       Module        d8P   ?88
#     88b      d88                   d888888P                d888888P  88b
#     888888b  888  ?88   d8P  d8888b  ?88'  d8888b   d8888b   ?88'    888888b
#     88P `?8b ?88  d88   88  d8b_,dP  88P  d8P' ?88 d8P' ?88  88P     88P `?8b
#    d88,  d88 88b  ?8(  d88  88b      88b  88b  d88 88b  d88  88b    d88   88P
#   d88'`?88P'  88b `?88P'?8b `?888P'  `?8b `?8888P' `?8888P'  `?8b  d88'   88b

# ~/.config/polybar/bluetooth.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays Bluetooth status and connected devices
# Dependencies : awk, bluetoothctl, rfkill

# ===============
# --- Options ---
# ===============

IFS='' # Allow spaces in arrays

# =================
# --- Functions ---
# =================

# Bluetooth State
function is_powered
{
  rfkill | grep 'bluetooth' | grep -q ' blocked'
  test $? -ne 0 # negate above command (hacky)
}

# Retrieve Device Info
function get_device_info
{
  bluetoothctl info $1
}

# Check Device Connection Status
function is_connected
{
  grep -q 'Connected: yes'
}

# Retrieve Paired Devices
function get_paired_devices
{
  bluetoothctl paired-devices
}

# =================
# --- Execution ---
# =================

# Check Interface
if is_powered; then
  typeset -a connections=()
  typeset -a device_names=()
  typeset -a device_addresses=()

  # Retrieve All Paired Devices
  paired_devices=$(get_paired_devices)

  # Build List of Device Aliases & MAC Addresses
  while read device; do
    device_names+=( $(awk '{for (i = 3; i <= NF; ++i) printf $i " "; print ""}' <<< "$device") )
    device_addresses+=( $(awk '{print $2}' <<< "$device") )
  done <<< "$paired_devices"

  # Check for Connected Devices
  for (( i = 0; i < ${#device_addresses[@]}; ++i )); do
    address=${device_addresses[$i]}
    is_connected <<< $(get_device_info "$address") && connections+=( ${device_names[$i]} )
  done

  # Compile Output
  if [[ ${#connections[@]} -eq 0 ]]; then
    icon=''
    colour='#FFB52A'
    output='Standby'
  else
    delimiter='  '
    printf -v output_raw "%s$delimiter" "${connections[@]}"

    icon=''
    colour='#1094D2'
    output="${output_raw%$delimiter}"
  fi

  # Print Output
  printf "%%{T4}%%{F$colour}$icon%%{F-}%%{T-}  %%{T5}${output% }%%{T-}"
else
  icon=''
  colour='#00DA90'
  output=''
  printf "%%{T4}%%{F$colour}$icon%%{F-}%%{T-}"
fi
