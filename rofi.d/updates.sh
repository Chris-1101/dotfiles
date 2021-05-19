#!/usr/bin/env bash
#                             d8b
#                             88P             d8P
#                            d88           d888888P
#   ?88   d8P?88,.d88b,  d888888   d888b8b   ?88'  d8888b .d888b,
#   d88   88 `?88'  ?88 d8P' ?88  d8P' ?88   88P  d8b_,dP ?8b,
#   ?8(  d88   88b  d8P 88b  ,88b 88b  ,88b  88b  88b       `?8b
#   `?88P'?8b  888888P' `?88P'`88b`?88P'`88b `?8b `?888P'`?888P'
#              88P'
#              d88
#             ?8P

# ~/.config/rofi/updates.sh

# Author       : Chris-1101 @ GitHub
# Description  : List system updates in custom rofi menu
# Dependencies : rofi

# =================
# --- Functions ---
# =================

# Remove Version Arrow
function remove_arrow
{
  # tr -d -- '->'
  sed 's/->//g'
}

# Add Hidden Tags
function tag_updates
{
  sed "s/\$/<span lang=\"$1\"><\/span>/g"
}

# Prefix Line Number
function number_lines
{
  local -i pad=$1
  nl -n rz -w $pad
}

# Set Custom Delimiter
function delimit_output
{
  column -t -o "$delimiter"
}

# Tabulate Output
function tabulate_output
{
  column -t -s "$delimiter" -o "$separator"
}

# Headers Formatting
function format_headers
{
  sed 's//<span size="large"><\/span>/g' | sed 's/PACKAGE /PACKAGE/g'
}

# Fix `column -t` Output
function fix_format
{
  sed -E 's/span\s*;lang/span lang/g'
}

# Hack
function insert_control_chars
{
  local null=$'\0'
  local unit=$'\x1f'
  # sed 's/X_NULL/\0/g' | sed 's/X_UNIT/\x1f/g'
  awk '{gsub(/X_NULL/,"\0");}1' | awk '{gsub(/X_UNIT/,"\xf1");}1'
}

# Determine Row Width
function count_max_width
{
  local -i width_min=54
  local -i width=$(wc -L <<< "$1")

  [[ $width -lt $width_min ]] && printf $width_min || printf $width
}

# Determine Height
function count_max_height
{
  local -i lines_max=8
  local -i lines=$(wc -l <<< "$1")

  [[ $lines -gt $lines_max ]] && printf $lines_max || printf $lines
}

# Line Count
function count_lines
{
  wc -l
}

# =================
# --- Execution ---
# =================

# Structure & Formatting
typeset -r delimiter=';'
typeset -r separator='   '
typeset -r headers="${delimiter}  PACKAGE${delimiter}  LOCAL${delimiter}  UPDATE"
typeset -r tag_format='<span lang="aur"></span>'
typeset -r tag_len=${#tag_format}

# Retrieve Updates
updates_pkg=$(remove_arrow < /tmp/updates_pkg | tag_updates pac)      # Load and tag updates from official repositories
updates_aur=$(remove_arrow < /tmp/updates_aur | tag_updates aur)      # Load and tag updates from the Arch User Repository

# No Updates
if [[ -z $updates_pkg ]] && [[ -z $updates_aur ]]; then
  rofi -config ~/.config/rofi/updates_none.rasi -e $'No pending updates\non any repository'
  exit 0
fi

# Build & Format Output
updates=$(printf '%s\n%s' "$updates_pkg" "$updates_aur")                # Combine update sources in single list
updates_len=$(count_lines <<< "$updates")                               # Count total lines within combined list
updates_indexed=$(number_lines ${#updates_len} <<< "$updates")          # Prefix lines with appropriately padded numbers
updates_tabular=$(delimit_output <<< "$updates_indexed" | fix_format)   # Use non-whitespace delimiter to allow spaces in cells
updates_headers=$(printf '%s\n%s' "$headers" "$updates_tabular")        # Add headers to the top of the combined list
output=$(tabulate_output <<< "$updates_headers" | format_headers)       # Format list into evenly spaced columns

# Calculate Width
row_max_chars=$(count_max_width "$updates_headers")                     # Determine character count of longest row
total_separator_len=$(( ${#separator} * 3 ))                            # Determine total separation chars (4 columns = 3 separators)
width=$(( (row_max_chars - tag_len + total_separator_len) / 2 ))        # Determine width of Rofi menu
lines=$(count_max_height "$output")

# Run Rofi
typeset -r title='System Updates'
typeset -r options="-i -dmenu -markup-rows -width $width -lines $lines -config ~/.config/rofi/updates.rasi"
rofi $options -p "$title" <<< "$output" > /dev/null || true
