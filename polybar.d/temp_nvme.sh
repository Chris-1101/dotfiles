#!/usr/bin/env bash

#       Sensor Temperature    Polybar Module

#      88bd88b ?88   d8P  88bd8b,d88b  d8888b
#     88P' ?8b d88  d8P' 88P'`?8P'?8b d8b_,dP
#    d88   88P ?8b ,88' d88  d88  88P 88b
#   d88'   88b `?888P' d88' d88'  88b `?888P'

# ~/.config/polybar/temp_nvme.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays temperature reported by nvme thermal sensor
# Dependencies : - N/A

# =================
# --- Functions ---
# =================

# Read NVME Composite Sensor
function get_nvme_composite_temp
{
  local sensor=/sys/class/hwmon/hwmon1/temp1_input
  local temp_raw=$(cat $sensor)
  local temp=${temp_raw:0:(-3)}.${temp_raw:(-3)}
  printf "%.0f" "${temp}"
}

# Format Output With Templates
function format_based_on_health
{
  local icon=""
  local reading="$1°C"
  local critical="#E60053"
  local warning="#FFB52A"

  if [[ $1 -gt 80 ]]; then
    icon=""
    reading="%%{F$critical}$reading%%{F-}"
  elif [[ $1 -gt 60 ]]; then
    icon=""
    reading="%%{F$warning}$reading%%{F-}"
  elif [[ $1 -gt 40 ]]; then
    icon=""
  elif [[ $1 -gt 20 ]]; then
    icon=""
  fi

  printf "$icon  $reading"
}

# =================
# --- Execution ---
# =================

temp=$(get_nvme_composite_temp)
echo "$(format_based_on_health $temp)"
