#!/usr/bin/env bash
#                      d8b                          d8b
#                     88P                          88P
#                     d88                         d88
#    d8888b  d888b8b  888   d8888b  88bd88b   d888888   d888b8b     88bd88b
#   d8P' `P d8P' ?88  ?88  d8b_,dP  88P' ?8b d8P' ?88  d8P' ?88     88P'  `
#   88b     88b  ,88b  88b 88b     d88   88P 88b  ,88b 88b  ,88b   d88
#   `?888P' `?88P'`88b  88b`?888P'd88'   88b `?88P'`88b`?88P'`88b d88'

# ~/.config/rofi/bluetooth.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays a Rofi menu with a calendar of the current month
# Dependencies : cal, rofi

# =================
# --- Functions ---
# =================

# Print Given Line
function print_line
{
  local -i line_no=$1
  sed -n ${line_no}p
}

# Pattern Replacement
function highlight_pattern
{
  local fg='#16161B'
  local bg='#acbcdae0'
  [[ ${#1} -le 1 ]] && local space=' '
  sed "0,/$space$1/s//<span foreground=\"$fg\" background=\"$bg\" weight=\"bold\">$space$1<\/span>/"
}

# =================
# --- Execution ---
# =================

# Variables
typeset -r cal=$(cal | grep -v '^ *$')
typeset -i lines=$(wc -l <<< "$cal")
typeset -r options="-dmenu -a 0 -lines $lines -markup-rows -config ~/.config/rofi/calendar.rasi"

# Launch Rofi
cal_header=$(print_line 1 <<< "$cal")
cal_body=$(sed '1d' <<< "$cal" | highlight_pattern "$(date +'%d' | sed 's/^0*//')")
printf '%s\n%s\n' "$cal_header" "$cal_body" | rofi $options > /dev/null || true
