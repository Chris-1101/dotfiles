#!/usr/bin/env bash

#   Power Control Script                                                d8b
#                                                               d8P    88P
#                                                            d888888P d88
#   ?88,.d88b,  d8888b  ?88   d8P  d8P d8888b  88bd88b d8888b  ?88'   888
#   `?88'  ?88 d8P' ?88 d88  d8P' d8P'd8b_,dP  88P'  `d8P' `P  88P    888
#     88b  d8P 88b  d88 ?8b ,88b ,88' 88b     d88     88b      88b    88b
#     888888P' `?8888P' `?888P'888P'  `?888P'd88'     `?888P'  `?8b    88b
#     88P'
#    d88
#   ?8P

# ~/.local/bin/powerctl
# /usr/local/bin/powerctl.sh

# Author       : Chris-1101 @ GitHub
# Description  : Monitor, and notify of, changes related to power state
# Dependencies : acpi, dunst, dunstify, light

# Options
typeset -r script_name='powerctl'          # Script name, used in logging
typeset -r bat_critical_action='suspend'   # Systemctl action taken at critical battery threshold
typeset -i bat_critical_pct=5              # Critical battery % threshold, triggers specified systemctl action
typeset -i bat_danger_pct=10               # Low battery % threshold, triggers a desktop notification
typeset -i night_mode_pct=1                # Night mode brightness, for use in complete darkness
typeset -r night_mode_x=0.5                # Night mode software-based multiplier (when 1% just isn't dark enough)
typeset -i day_mode_bat=10                 # Day mode brightness (low end), for use on battery
typeset -i day_mode_ac=30                  # Day mode brightness (high end), for use on AC

# Locations
typeset -r bl_brightness_ac="$HOME/.config/bl-brightness-ac"
typeset -r bl_brightness_bat="$HOME/.config/bl-brightness-bat"
typeset -r bl_brightness_last="$HOME/.config/bl-brightness-last"

# ===================
# --- Environment ---
# ===================

# D-Bus / Notifications
export DISPLAY=:0
export XAUTHORITY=$HOME/.Xauthority
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID/bus"

# ===============
# --- Helpers ---
# ===============

# Logger
function logger
{
  if [[ -t 1 ]]; then
    printf '%s\n' "$@"
  else
    systemd-cat -p info -t "$script_name" <<< "$@"
  fi
}

# Notifications
function notify
{
  local header='Power Control'
  local -i id=77834

  # Params: 1 = urgency, 2 = message, 3 = icon
  dunstify -u "$1" "$header" "$2" -i "$3" -r $id
}

# 0-100 Range Check
function is_valid_percentage
{
  [[ $1 -ge 0 ]] && [[ $1 -le 100 ]]
}

# Power Status
function is_plugged_in
{
  acpi -a | grep -q 'on-line'
}

# Wake Screen on Xorg
function wake_screen
{
  xset s reset
}

# =================
# --- Functions ---
# =================

# Check Cache
function initialise
{
  test ! -f $bl_brightness_bat && printf $day_mode_bat > $bl_brightness_bat
  test ! -f $bl_brightness_ac && printf $day_mode_ac > $bl_brightness_ac
}

# Set Software BL Multiplier
function set_bl_multiplier
{
  logger "Setting backlight software multiplier to $1 via xrandr"
  xrandr --output 'eDP-1' --brightness $1
}

# Get Current Screen Brightness
function get_bl_brightness
{
  printf '%.0f' $(light -G)
}

# Set Screen Brightness
function set_bl_brightness
{
  local -i value="$1"
  logger "Setting backlight brightness to $value"
  light -S $value
  # ~/.local/bin/backlightctl -g
}

# Save Screen Brightness
function save_bl_brightness
{
  local -i value=$(get_bl_brightness)

  case "$1" in
    'ac') [[ $value -ne $night_mode_pct && $value -ne 0 ]] && printf "$value" > $bl_brightness_ac ;;
    'bat') [[ $value -ne $night_mode_pct && $value -ne 0 ]] && printf "$value" > $bl_brightness_bat ;;
    *) exit 1 ;;
  esac
}

# Load Screen Brightness
function load_bl_brightness
{
  case "$1" in
    'ac') cat $bl_brightness_ac ;;
    'bat') cat $bl_brightness_bat ;;
    *) exit 1 ;;
  esac
}

# ===================
# --- Power State ---
# ===================

# Check Battery
function check_bat
{
  is_plugged_in && exit 0

  local -i bat_pct=$(acpi -b | awk '{print $4}' | tr -d '%,')
  local msg="Battery critically low ($bat_pct%)"
  local icon='~/Pictures/Icons/batlow.png'

  if [[ $bat_pct -le $bat_critical_pct ]]; then
    logger "$msg - suspending"
    systemctl suspend
  elif [[ $bat_pct -le $bat_danger_pct ]]; then
    notify 'critical' "$msg" "$icon"
    logger "$msg"
  fi
}

# ========================
# --- Power Transition ---
# ========================

# Save Current Power Source
function save_power_source
{
  printf "$1" > $bl_brightness_last
}

# Check Current Power Source
function matches_previous_source
{
  local next_source="$1"
  local last_source=$(cat $bl_brightness_last)

  test "$last_source" = "$next_source"
}

# Switch to AC Brightness
function switch_ac
{
  local icon='~/Pictures/Icons/plug.png'

  wake_screen
  save_power_source ac
  save_bl_brightness bat
  set_bl_brightness $(load_bl_brightness ac)
  set_bl_multiplier 1

  notify 'normal' 'Power supply connected' "$icon"
}

# Switch to Battery Brightness
function switch_bat
{
  local icon='~/Pictures/Icons/batinfo.png'

  wake_screen
  save_power_source bat
  save_bl_brightness ac
  set_bl_brightness $(load_bl_brightness bat)
  set_bl_multiplier 1

  notify 'normal' 'Power supply disconnected' "$icon"
}

# ========================
# --- Brightness Modes ---
# ========================

# Toggle Screen
function toggle_screen
{
  local -i bl_pct=$(get_bl_brightness)

  if [[ $bl_pct -eq 0 ]]; then
    is_plugged_in

    case "$?" in
      0) local -i value=$(load_bl_brightness ac) ;;
      1) local -i value=$(load_bl_brightness bat) ;;
    esac

    set_bl_brightness $value
    set_bl_multiplier 1
  else
    set_bl_brightness 0
  fi
}

# Switch to Night Mode
function switch_night
{
  is_plugged_in

  case "$?" in
    0) save_bl_brightness ac ;;
    1) save_bl_brightness bat ;;
  esac

  set_bl_brightness $night_mode_pct
  set_bl_multiplier $night_mode_x

  local icon='~/Pictures/Icons/stars.png'
  notify 'normal' 'Switched to night mode' "$icon"
}

# Switch to Day Mode
function switch_day
{
  is_plugged_in

  case "$?" in
    0) local -i value=$(load_bl_brightness ac) ;;
    1) local -i value=$(load_bl_brightness bat) ;;
  esac

  set_bl_brightness $value
  set_bl_multiplier 1

  local icon='~/Pictures/Icons/sunrise.png'
  notify 'normal' 'Switched to day mode' "$icon"
}

# ===================
# --- Main Script ---
# ===================

# Initial Value
initialise

# Parameters
case "$1" in
  -a | --ac) matches_previous_source 'ac' || switch_ac ;;
  -b | --bat) matches_previous_source 'bat' || switch_bat ;;
  -d | --day) switch_day ;;
  -n | --night) switch_night ;;
  -c | --check) check_bat ;;
  -t | --toggle) toggle_screen ;;
  *) exit 1
esac
