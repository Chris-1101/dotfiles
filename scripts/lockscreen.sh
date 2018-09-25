#!/usr/bin/env bash

#   ██╗      ██████╗  ██████╗██╗  ██╗    ███████╗ ██████╗██████╗ ███████╗███████╗███╗   ██╗
#   ██║     ██╔═══██╗██╔════╝██║ ██╔╝    ██╔════╝██╔════╝██╔══██╗██╔════╝██╔════╝████╗  ██║
#   ██║     ██║   ██║██║     █████╔╝     ███████╗██║     ██████╔╝█████╗  █████╗  ██╔██╗ ██║
#   ██║     ██║   ██║██║     ██╔═██╗     ╚════██║██║     ██╔══██╗██╔══╝  ██╔══╝  ██║╚██╗██║
#   ███████╗╚██████╔╝╚██████╗██║  ██╗    ███████║╚██████╗██║  ██║███████╗███████╗██║ ╚████║
#   ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝

# install:set type=root path=/usr/bin/lockscreen

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Simple lock screen script based on 'betterlockscreen' by Pavan Jadhaw
# Dependencies : i3lock-color

logger '[ARCLIGHT] Initialising lockscreen...'

# ==================================
# ------- Lock Script Proper -------
# ==================================
function lock
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
    --radius=22 --ring-width=3 --veriftext="" --wrongtext="" \
    --textcolor="$foreground" --timecolor="$foreground" --datecolor="$foreground" \
    --force-clock &
}

# =======================================
# ------- Suspend/Resume Services -------
# =======================================
function pre_lock
{
  pkill -u "$USER" -USR1 dunst
}

function post_lock
{
  sleep 1
  pkill -u "$USER" -USR2 dunst
}

# ============================
# ------- List Options -------
# ============================
function help
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
  echo "ps: yes, these options are rather redundant at this point :p"
  echo
}

# ===============================
# ------- Option Handling -------
# ===============================
case $1 in
  "")
    ;&
  -l|--lock)
    lock
    ;;
  -h|--help)
    help
    ;;
  *)
    echo "Unknown option: $1"
    echo "Run $0 -h for help."
    ;;
esac
