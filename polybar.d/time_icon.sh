#!/usr/bin/env bash

#            d8,                            d8,
#      d8P   `8P                            `8P         Polybar Module
#   d888888P
#     ?88'   88b  88bd8b,d88b   d8888b      88b  d8888b  d8888b   88bd88b
#     88P    88P  88P'`?8P'?8b d8b_,dP      88P d8P' `P d8P' ?88  88P' ?8b
#     88b   d88  d88  d88  88P 88b         d88  88b     88b  d88 d88   88P
#     `?8b d88' d88' d88'  88b `?888P'    d88'  `?888P' `?8888P'd88'   88b

# ~/.config/polybar/time_icon.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays icon corresponding to time of day
# Dependencies : - N/A

# =================
# --- Functions ---
# =================

# Get Icon
function get_icon_for_time
{
  case "$1" in
    21 | 22 | 23 | 00 | 01 | 02 | 03 | 04 | 05 )   printf '望'  ;;
    06 )                                           printf ''  ;;
    07 )                                           printf ''  ;;
    08 | 09 | 10 )                                 printf ' ' ;;
    11 | 12 | 13 | 14 | 15 | 16 )                  printf ''  ;;
    17 | 18 )                                      printf ' ' ;;
    19 )                                           printf ''  ;;
    20 )                                           printf ''  ;;

    * ) printf "" ;;
  esac
}

# Get Colour
function get_colour_for_time
{
  if [ $1 -ge 7 ] && [ $1 -le 19 ]; then
    printf 'FFB52A'
  else
    printf '05ADFF'
  fi
}

# Get Right Padding
function get_padding_for_time
{
  [[ ! '08 09 10 17 18' =~ $1 ]] && printf ' '
}

# Get Font
function get_font_for_time
{
  if [ $1 -ge 7 ] && [ $1 -le 19 ]; then
    printf '2'
  else
    printf '4'
  fi
}

# =================
# --- Execution ---
# =================

# Retrieve Info
hour=$(date +%H)
icon=$(get_icon_for_time "$hour")
colour=$(get_colour_for_time "$hour")
padding=$(get_padding_for_time "$hour")
font=$(get_font_for_time "$hour")

# Print Result
printf '%%{F#%s}%%{T%s}%s%%{T-}%%{F-}%s' "$colour" "$font" "$icon" "$padding"
