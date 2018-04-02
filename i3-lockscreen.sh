#!/usr/bin/env bash

#   ██╗      ██████╗  ██████╗██╗  ██╗    ███████╗ ██████╗██████╗ ███████╗███████╗███╗   ██╗
#   ██║     ██╔═══██╗██╔════╝██║ ██╔╝    ██╔════╝██╔════╝██╔══██╗██╔════╝██╔════╝████╗  ██║
#   ██║     ██║   ██║██║     █████╔╝     ███████╗██║     ██████╔╝█████╗  █████╗  ██╔██╗ ██║
#   ██║     ██║   ██║██║     ██╔═██╗     ╚════██║██║     ██╔══██╗██╔══╝  ██╔══╝  ██║╚██╗██║
#   ███████╗╚██████╔╝╚██████╗██║  ██╗    ███████║╚██████╗██║  ██║███████╗███████╗██║ ╚████║
#   ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Simple lock screen script based on `betterlockscreen` by Pavan Jadhaw
# Dependencies : i3lock-color

# ==================================
# ------- Lock Script Proper -------
# ==================================
lock()
{
    # Colours (rrggbbaa)
    foreground=d7d8e0ff
    accentColour=525b81ff
    errorColour=d23c3dff
    transparent=00000000

    # Lock Screen Background
    bg="$HOME/Pictures/lockscreen.png"

    # i3lock Script
    i3lock \
        -t -n -i $bg \
        --timesize=65 \
        --datesize=24 \
        --timepos="x+130:h-ch-48" \
        --datepos="tx+10:ty+35" \
        --time-align=1 --date-align=1 \
        --timefont='DejaVu Sans Light' \
        --clock --datestr "Type password to unlock..." \
        --insidecolor=$transparent --ringcolor=$foreground --line-uses-inside \
        --keyhlcolor=$accentColour --bshlcolor=$accentColour --separatorcolor=$transparent \
        --insidevercolor=$transparent --insidewrongcolor=$errorColour \
        --ringvercolor=$foreground --ringwrongcolor=$foreground --indpos="x+638:h-159" \
        --radius=22 --ring-width=3 --indicator --veriftext="" --wrongtext="" \
        --textcolor="$foreground" --timecolor="$foreground" --datecolor="$foreground" \
        --force-clock &
}

# ============================
# ------- List Options -------
# ============================
help()
{
    echo
    echo "Simple lock screen script to automate the use of i3lock-color"
    echo "https://github.com/Chris-1101/dotfiles"
    echo
    echo "Options:"
    echo
    echo "    -h --help"
    echo "        Displays this page"
    echo
    echo "    -l --lock"
    echo "        Locks the screen (default)"
    echo
    echo "    -s --suspend"
    echo "        Locks the screen and suspends the system"
    echo
    echo "    -b --hibernate"
    echo "        Locks the screen and hibernates the system"
    echo
}

# ===============================
# ------- Option Handling -------
# ===============================
case $1 in

    "")

        ;&

    -l | --lock)

        lock
        ;;

    -s | --suspend)

        lock
        sleep 1
        systemctl suspend
        ;;

    -b | --hibernate)

        lock
        sleep 1
        systemctl hibernate
        ;;

    -h | --help)

        help
        ;;

    *)

        echo "Unknown option: $1"
        echo "Run $0 -h for help."
        ;;

esac
