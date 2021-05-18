#!/usr/bin/env bash
#
#          d8b d8,                       d8b                                     d8b
#         88P  `8P                      88P                              d8P    88P
#        d88                           d88                            d888888P d88
#    d888888    88b .d888b,?88,.d88b, d88   d888b8b  ?88   d8P  d8888b  ?88'  d88
#   d8P' ?88    88P ?8b,   `?88'  ?88 88(  d8P' ?88  d88   88  d8P' `P  88P   88(
#   88b  ,88b  d88    `?8b   88b  d8P 88b  88b  ,88b ?8(  d88  88b      88b   88b
#   `?88P'`88bd88' `?888P'   888888P' `88b `?88P'`88b`?88P'?8b `?888P'  `?8b  `88b
#                            88P'                          )88
#                           d88                           ,d8P
#                          ?8P                        `?888P'

# ~/.local/bin/displayctl

# Author       : Chris-1101 @ GitHub
# Description  : Manages tasks required to setup WM for external displays
# Dependencies : pcregrep, xrandr (Xorg Resize AND Rotate)

# ===============
# --- Options ---
# ===============

# Shell Options
set -o errexit    # Exit on errors
set -o pipefail   # Fail pipeline on errors
set -o nounset    # Exit on unset variables

# Display Options
readonly main='eDP-1'
readonly bg_main="$HOME/Pictures/Wallpapers/16 Bit Sunset - Bright Sky Mod (1080) SC2.png"
readonly bg_ext="$HOME/Pictures/Wallpapers/16 Bit Sunset - IPS Mod (UWQHD).png"

# =================
# --- Functions ---
# =================

function find_first_external_display
{
  # Capture first word that's followed by "connected" and not followed by "primary"
  local -r pattern='^([\w-]*)\s(?:connected)\s(?!primary).*$'
  local -a results=($(pcregrep -o1 "$pattern" <<< $(xrandr --query)))

  printf "${results[0]}"
}

function get_display_resolution
{
  local -r display=$1
  local -r pattern='(\d{4})x(\d{4})'

  xrandr --query | grep -A1 "$display" | pcregrep -o1 -o2 --om-separator=' ' "$pattern"
}

function connect_display
{
  local -r display=$1

  xrandr --output "$display" --auto
}

function connect_external_display
{
  local -r display=$1
  local -r position=$2

  # Eternal Display Geometry
  local -ar res_external=($(get_display_resolution "$display"))
  local -ir res_ext_horizontal=${res_external[0]}
  local -ir res_ext_vertical=${res_external[1]}

  # Main Display Geometry
  local -ar res_internal=($(get_display_resolution 'eDP-1'))
  local -ir res_int_horizontal=${res_internal[0]}
  local -ir res_int_vertical=${res_internal[1]}

  local -ir offset_horizontal=$(( res_ext_horizontal / 2 - res_int_horizontal / 2 ))

  # Only Optional Available (for now)
  if [[ $position = '--above' ]]; then
    xrandr --output "$main" --auto --primary --pos "${offset_horizontal}x$res_ext_vertical" --output "$display" --auto --pos '0x0'
    # xrandr --output "$main" --auto --output "$display" --auto "$position" "$main"
  else
    exit 1
  fi
}

function disconnect_display
{
  local -r display=$1

  xrandr --output "$display" --off
}

function set_both_backgrounds
{
  feh --bg-scale "$bg_main" --bg-scale "$bg_ext"
}

function set_external_background
{
  feh --bg-scale "$bg_ext"
}

function set_main_background
{
  feh --bg-scale "$bg_main"
}

function move_i3_workspace_to_display
{
  local -r display=$1

  i3-msg move workspace to output "$display"
}

function relaunch_polybar
{
  ~/.config/polybar/launch.sh
}

# ========================
# --- Display Profiles ---
# ========================

# Laptop Only
function load_profile_laptop
{
  connect_display "$main"
  disconnect_display "$external"
  set_main_background
}

# Laptop + External
function load_profile_docked
{
  connect_external_display "$external" --above
  set_both_backgrounds
}

#External Only
function load_profile_external
{
  connect_display "$external"
  disconnect_display "$main"
  set_external_background
}

# =================
# --- Execution ---
# =================

# Determine Display
typeset -r external=$(find_first_external_display)

# Options
case "$1" in
  -a | --above    ) load_profile_docked ;;
  # -b | --below    ) ;;
  -e | --external ) load_profile_external ;;
  -i | --internal ) load_profile_laptop ;;
  # -l | --left-of  ) ;;
  # -m | --mirror   ) ;;
  # -r | --right-of ) ;;
esac

# Update Bars
relaunch_polybar

# NOTE: No need to call polybar hook as entire process is reloaded
