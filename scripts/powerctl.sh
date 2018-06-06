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
# Dependencies : dunstify

# ==============================
# ------- 𝙎𝙘𝙧𝙞𝙥𝙩 𝙊𝙥𝙩𝙞𝙤𝙣𝙨 -------
# ==============================
# At what battery percentage should a notification be displayed
bat_low=10

# At what battery percentage should action be taken to preserve system state
bat_critical=5

# What action should be taken? Must be valid systemctl command [suspend/hibernate]
bat_action="suspend"

# Screen brightness to set on ac/bat swap
bl_ac=50
bl_bat=30

# ===================================
# ------- 𝙁𝙪𝙣𝙘𝙩𝙞𝙤𝙣 𝘿𝙚𝙛𝙞𝙣𝙞𝙩𝙞𝙤𝙣𝙨 -------
# ===================================
# Get Battery Level
function get_bat_pct
{
    local bat_id=$(grep '^BAT' <<< $(ls /sys/class/power_supply))
    local bat_path="/sys/class/power_supply/$bat_id"
    local bat_pct=$(cat $bat_path/capacity)

    echo $bat_pct
}

# Check Battery Thresholds
function check_bat_pct
{
    # local bat_level=`get_bat_pct`
    local bat_level=10
    local bat_time=$(awk -F '[\s,]' '{print $4}' <<< $(acpi -b))

    if [[ $bat_level -le $bat_critical ]]; then
        systemctl $bat_action
    elif [[ $bat_level -le $bat_low ]]; then
        dunstify "Power Control" "Battery critically low: ${bat_level}% (${bat_time//$' remaining'})" -u critical -t 0 -r 90271
    fi
}

# AC ➤ Battery
function ac_unplugged
{
    local bat_level=`get_bat_pct`
    local message=$(echo -e "A/C Supply Unplugged\nBattery is at")

    dunstify "Power Control" "$message ${bat_level}%" -u critical -t 7000 -r 90271
    light -S $bl_bat
}

# Battery ➤ AC
function ac_pluggedin
{
    local message="A/C Supply Plugged In"

    dunstify "Power Control" "$message" -u critical -t 7000 -r 90271
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
        check_bat_pct
        ;;
    *)
        (>&2 echo "Unknown command: $1")
        exit 1
        ;;
esac
