#!/usr/bin/env bash
#                                              __   __
#   ______   ______  _  __ ___________   _____/  |_|  |
#   \____ \ /  _ \ \/ \/ // __ \_  __ \_/ ___\   __\  |
#   |  |_> >  <_> )     /\  ___/|  | \/\  \___|  | |  |__
#   |   __/ \____/ \/\_/  \___  >__|    \___  >__| |____/
#   |__|                      \/            \/

#!!:/usr/bin/powerctl

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Monitor, and notify of, changes related to the power supply
# Dependencies : acpi, dunstify

# NOTE: This script is designed with automation in mind via acpi events and/or systemd timers (or equivalent)

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

# Screen brightness to set on ac/battery swap
bl_ac=50
bl_bat=30

# ID used for notifications, can be ignored
not_id=90271

# Required for udev notifications
export DISPLAY=:0
export XAUTHORITY=$HOME/.Xauthority
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID/bus"

# ===================================
# ------- 𝙁𝙪𝙣𝙘𝙩𝙞𝙤𝙣 𝘿𝙚𝙛𝙞𝙣𝙞𝙩𝙞𝙤𝙣𝙨 -------
# ===================================
# Get Battery Info
function get_bat_info
{
    local method="/sys/class/power_supply"
    local bat_id=$(grep '^BAT' <<< $(ls $method))
    local bat_path="$method/$bat_id"
    local bat_status=$(cat $bat_path/status)
    local bat_pct=$(cat $bat_path/capacity)

    [[ $1 = "status" ]] && echo $bat_status
    [[ $1 = "pct" ]] && echo $bat_pct
}

# Check Battery Thresholds
function check_bat
{
    function is_discharging
    {
        test `get_bat_info status` = "Discharging"
    }

    ! is_discharging && exit 0

    local bat_level=`get_bat_info pct`
    local bat_time=$(awk -F '[, ]' '{print $7, $8}' <<< $(acpi -b))
    local lf=$(echo -e "\n(")

    if [[ $bat_level -le $bat_critical ]]; then
        systemctl $sys_action
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

    dunstify "$script_name" "$message ${bat_level}%" -t 7000 -r $not_id
    light -S $bl_bat
}

# Battery ➤ AC
function ac_pluggedin
{
    local message="A/C Supply Plugged In"

    dunstify "$script_name" "$message" -t 7000 -r $not_id
    light -S $bl_ac
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
