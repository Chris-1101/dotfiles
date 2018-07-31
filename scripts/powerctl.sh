#!/usr/bin/env bash
#                                              __   __
#   ______   ______  _  __ ___________   _____/  |_|  |
#   \____ \ /  _ \ \/ \/ // __ \_  __ \_/ ___\   __\  |
#   |  |_> >  <_> )     /\  ___/|  | \/\  \___|  | |  |__
#   |   __/ \____/ \/\_/  \___  >__|    \___  >__| |____/
#   |__|                      \/            \/

# install:set type=root path=/usr/bin/powerctl

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Monitor, and notify of, changes related to the power supply
# Dependencies : acpi, dunstify, light

# NOTE: This script should be automated via udev rules and/or systemd timers
# NOTE: The usage of 'sudo systemctl' will require sudoers rule

# ==============================
# ------- 𝙎𝙘𝙧𝙞𝙥𝙩 𝙊𝙥𝙩𝙞𝙤𝙣𝙨 -------
# ==============================
# The name of the script as it appears on notifications
script_name="Power Control"

# At what battery percentage should a notification be displayed
bat_low=10

# At what battery percentage should action be taken to preserve system state
bat_critical=5

# What action should be taken? Must be a valid systemctl command [suspend/hibernate]
sys_action="suspend"

# Default screen brightness set on ac/battery swap, used when no prior values exist
bl_ac=50
bl_bat=30

# ID used for notifications, can be ignored
not_id=90271

# Required for udev notifications
export DISPLAY=:0
export XAUTHORITY=$HOME/.Xauthority
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID/bus"

# ================================
# ------- 𝙐𝙩𝙞𝙡𝙞𝙩𝙮 𝙁𝙪𝙣𝙘𝙩𝙞𝙤𝙣𝙨 -------
# ================================
# Get Battery Info
function get_bat_info
{
  local method="/sys/class/power_supply"
  local bat_id=$(grep '^BAT' <<< $(ls $method))
  local bat_path="$method/$bat_id"
  local bat_status=$(cat $bat_path/status)
  local bat_pct=$(cat $bat_path/capacity)

  case "$1" in
    status)
      echo $bat_status
      ;;
    pct)
      echo $bat_pct
      ;;
  esac
}

# Determine Power Source
function is_discharging
{
  test `get_bat_info status` = "Discharging"
}

# Get Path for Backlight Values
function get_path
{
  case "$1" in
    bat)
      echo ~/.cache/backlight-bat
      ;;
    ac)
      echo ~/.cache/backlight-ac
      ;;
  esac
}

# Wake Screen on Xorg
function wake_screen
{
  xset s reset
}

# Store Brightness Level
function save_brightness
{
  local backlight_pct=$(awk '{$i = int( ($i + 2) / 5) * 5 ""} 1' <<< "$(light -G)")

  case "$1" in
    bat)
      local save_path=$(get_path bat)
      ;;
    ac)
      local save_path=$(get_path ac)
      ;;
    *)
      return
  esac

  [[ ! -e $save_path ]] && touch $save_path
  [[ $backlight_pct -eq 0 ]] && backlight_pct=10

  echo $backlight_pct > $save_path
}

# Restore Brightness Level
function load_brightness
{
  case "$1" in
    bat)
      local load_path=$(get_path bat)
      local bl_default=$bl_bat
      ;;
    ac)
      local load_path=$(get_path ac)
      local bl_default=$bl_ac
      ;;
    *)
      return
  esac

  if [[ -e $load_path ]]; then
    local backlight_pct=$(cat $load_path)

    if [[ -z $backlight_pct ]]; then
      backlight_pct=$bl_default
    fi
  else
    local backlight_pct=$bl_default
  fi

  light -S $backlight_pct
}

# ==================================
# ------- 𝙋𝙧𝙞𝙢𝙖𝙧𝙮　𝙁𝙪𝙣𝙘𝙩𝙞𝙤𝙣𝙨 -------
# ==================================
# Check Battery Thresholds
function check_bat
{
  ! is_discharging && exit 0

  local bat_level=`get_bat_info pct`
  local bat_time=$(awk -F '[, ]' '{print $7, $8}' <<< $(acpi -b))
  local lf=$(echo -e "\n(")

  if [[ $bat_level -le $bat_critical ]]; then
    sudo systemctl $sys_action
  elif [[ $bat_level -le $bat_low ]]; then
    dunstify "$script_name" "Battery Critically Low: ${bat_level}%${lf}${bat_time})" \
    -u critical -t 0 -r $not_id
  fi
}

# AC ➤ Battery
function ac_unplugged
{
  local bat_level=`get_bat_info pct`
  local message=$(echo -e "A/C Supply Unplugged\nBattery is at")
  local load_path=~/.backlightctl-bat

  wake_screen
  save_brightness ac && load_brightness bat
  dunstify "$script_name" "$message ${bat_level}%" -t 7000 -r $not_id
}

# Battery ➤ AC
function ac_pluggedin
{
  local message="A/C Supply Plugged In"
  local load_path=~/.backlightctl-ac

  wake_screen
  save_brightness bat && load_brightness ac
  dunstify "$script_name" "$message" -t 7000 -r $not_id
}

# =======================================
# ------- 𝙋𝙖𝙧𝙖𝙢𝙚𝙩𝙚𝙧 𝙈𝙖𝙣𝙖𝙜𝙚𝙢𝙚𝙣𝙩 -------
# =======================================
case "$1" in
  "")
    printf "Missing argument - "
    ;&
  -h|--help)
    printf "usage: $(basename $0) [ac/bat/low]\n"
    exit 0
    ;;
  ac)
    ac_pluggedin
    ;;
  bat)
    ac_unplugged
    ;;
  low)
    check_bat
    ;;
  *)
    (>&2 echo "Unknown command: $1")
    exit 1
    ;;
esac
