#!/usr/bin/env bash
#
#          d8b d8,                       d8b
#         88P  `8P                      88P
#        d88                           d88
#    d888888    88b .d888b,?88,.d88b, d88   d888b8b  ?88   d8P
#   d8P' ?88    88P ?8b,   `?88'  ?88 88(  d8P' ?88  d88   88
#   88b  ,88b  d88    `?8b   88b  d8P 88b  88b  ,88b ?8(  d88
#   `?88P'`88bd88' `?888P'   888888P' `88b `?88P'`88b`?88P'?8b
#                            88P'                          )88
#                           d88                           ,d8P
#                          ?8P                        `?888P'

# ~/.config/rofi/display.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays a rofi menu with options to setup external displays
# Dependencies : pcregrep, rofi, xrandr

# ===============
# --- Options ---
# ===============

# Shell Options
set -o errexit    # Exit on errors
set -o pipefail   # Fail pipeline on errors
set -o nounset    # Exit on unset variables

# Rofi Options
readonly config="-config ~/.config/rofi/display.rasi"
readonly options="-dmenu -markup-rows $config"

# Display Modes - External Display Connected
readonly -a modes_external=(
  ",Extend Above"
  # ',Extend Below'
  # ',Extend Right'
  # ',Extend Left'
  # ',Mirror Displays'
  ",External Only"
  ",Internal Only"
)

# Display Modes - Only Internal Display
readonly -a modes_internal=(
  "ﰸ,Extend Above"
  # 'ﰸ,Extend Below'
  # 'ﰸ,Extend Right'
  # 'ﰸ,Extend Left'
  # 'ﰸ,Mirror Displays'
  "ﰸ,External Only"
  ",Internal Only"
)

# =================
# --- Functinos ---
# =================

function find_external_displays
{
  # Capture first word that's followed by "connected" and not followed by "primary"
  local -r pattern='^([\w-]*)\s(?:connected)\s(?!primary).*$'
  local -a results=($(pcregrep -o1 "$pattern" <<< $(xrandr --query)))

  printf "${results[@]}"
}

function has_external_display
{
  local -ar displays=($(find_external_displays))
  test "${#displays[@]}" -gt 0
}

function get_display_mode
{
  has_external_display

  [[ $? -eq 0 ]] && printf 'external' || printf 'internal'
}

function build_menu_from_content
{
  local -ar content=($@)

  local -r typeface='DejaVuSansMono Nerd Font normal'
  local -r typesize=12
  local -r lf=$'\n'

  local result components icon text

  for e in "${content[@]}"; do
    components=(${e//,/ })
    icon=${components[0]}
    text=${components[1]}

    result+="<span font_desc=\"$typeface $typesize\">$icon</span>     $text$lf"
  done

  printf "$result"
}

function rofi_launcher
{
  local -r entries=$1
  local -ir width=$2

  local -ir lines="$(wc -l <<< "$entries")"

  printf "$entries" | rofi $options -lines $lines -width $width
}

function call_displayctl
{
  ~/.local/bin/displayctl $@
}

# =================
# --- Execution ---
# =================

# Display Selection
# typeset -ar displays=($(find_external_displays))
# typeset -r displays_menu=$(build_menu_from_content ${displays[@]})
# typeset -r monitor=$(rofi_launcher "$displays_menu" 10)

# User Aborted Selection
# [[ -z $monitor ]] && exit 0 || monitor=${monitor##*> }

# Display Mode Selection
typeset -n modes="modes_$(get_display_mode)"
typeset -r modes_menu=$(build_menu_from_content ${modes[@]})
typeset -r mode=$(rofi_launcher "$modes_menu" 9)

# Forward Call
case "${mode##*>     }" in
  "Extend Above"  ) call_displayctl --above    ;;
  "External Only" ) call_displayctl --external ;;
  "Internal Only" ) call_displayctl --internal ;;
esac
