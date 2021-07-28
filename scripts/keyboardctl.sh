#!/usr/bin/env bash
#
#    d8b                          d8b                                         d8b                   d8b
#    ?88           razer          ?88                                        88P            d8P    88P
#     88b                          88b                                       d88         d888888P ?88
#     888  d88' d8888b ?88   d8P   888888b   d8888b   d888b8b    88bd88b d888888   d8888b  ?88'   888
#     888bd8P' d8b_,dP d88   88    88P `?8b d8P' ?88 d8P' ?88    88P'  `d8P' ?88  d8P' `P  88P    ?88
#    d88888b   88b     ?8(  d88   d88,  d88 88b  d88 88b  ,88b  d88     88b  ,88b 88b      88b    88b
#   d88' `?88b,`?888P' `?88P'?8b d88'`?88P' `?8888P' `?88P'`88bd88'     `?88P'`88b`?888P'  `?8b    88b
#                             )88
#                            ,d8P    Chroma Backlight Control Script
#                         `?888P'

# ~/.local/bin/keyboardctl

# Author       : Chris-1101 @ GitHub
# Description  : Controls various aspects of Razer Chroma backlit keyboard
# Dependencies : dunst, dunstify, light

# ===============
# --- Options ---
# ===============

# System Paths
typeset -r chroma_device=$(light -L | grep 'razer/.*/backlight' | tr -d '[[:space:]]')
typeset -r chroma_base=/sys/bus/hid/drivers/razerkbd/$(grep -oP '.{4}:.{4}:.{4}\..{4}' <<< "$chroma_device")
typeset -r chroma_static=${chroma_base}/matrix_effect_static
typeset -r kb_brightness=~/.config/kb-brightness
typeset -r script_name='keyboardctl'

# ===============
# --- Helpers ---
# ===============

# Logger
source "$(dirname $0)/lib/logger.sh"

# Round to Nearest
function round
{
  read value
  printf '%.0f' $value
}

# 0-100 Range Check
function is_valid_percentage
{
  [[ $1 -ge 0 ]] && [[ $1 -le 100 ]]
}

# ==============
# --- Colour ---
# ==============

# Hex RGB Check
function is_valid_rgb
{
  local hex_pattern='^[0-9a-fA-F]{6}$'
  [[ $1 =~ $hex_pattern ]]
}

# Set Keyboard Backlight Colour
function set_chroma_colour
{
  local colour=$(sed 's/../\\x&/g' <<< $1)

  logger $script_name "Setting keyboard backlight to #$1"
  printf "$colour" > "$chroma_static"
}

# ==================
# --- Brightness ---
# ==================

# Notifications
function notify
{
  local urgency='low'
  local header='Chroma Control'
  local icon='~/Pictures/Icons/keyboard.png'
  local -i id=29857

  dunstify -u "$urgency" "$header" "$1" -i "$icon" -r $id
}

# Initialise Cache
function initialise
{
  test $(get_chroma_brightness) -eq 0 && set_chroma_brightness 100 || save_chroma_brightness
}

# Turn Keyboard Off
function disable_chroma
{
  set_chroma_brightness 0
  notify 'Chroma backlight disabled'
}

# Turn Keyboard On
function enable_chroma
{
  local -i brightness=$(load_chroma_brightness)
  set_chroma_brightness $brightness
  notify 'Chroma backlight enabled'
}

# Get Keyboard Backlight Level
function get_chroma_brightness
{
  light -s $chroma_device | xargs printf '%.0f'
}

# Set Keyboard Backlight Level
function set_chroma_brightness
{
  local -i value="$1"
  logger "Setting keyboard brightness to $value"
  light -s $chroma_device -S $value
  save_chroma_brightness
}

# Save Current Backlight Level
function save_chroma_brightness
{
  local -i value=$(get_chroma_brightness)
  [[ $value != 0 ]] && printf $value > $kb_brightness || true
}

# Retrieve Saved Backlight Level
function load_chroma_brightness
{
  cat $kb_brightness
}

# Toggle Backlight
function toggle_chroma
{
  local -i brightness=$(get_chroma_brightness)

  if [[ $brightness -eq 0 ]]; then
    enable_chroma
  else
    save_chroma_brightness
    disable_chroma
  fi
}

# ==============
# --- Script ---
# ==============

# Initial Value
test -f $kb_brightness || initialise

# Options
case "$1" in
  -c | --colour) shift && is_valid_rgb $1 && set_chroma_colour $1 ;;
  -b | --brightness) shift && is_valid_percentage $1 && set_chroma_brightness $1 ;;
  -t | --toggle) toggle_chroma ;;
  -0 | --off) disable_chroma ;;
  -1 | --on) enable_chroma ;;
  "") toggle_chroma ;;
  *) exit 1 ;;
esac
