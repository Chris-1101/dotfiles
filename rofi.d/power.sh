#!/usr/bin/env bash
#
#   ?88,.d88b,  d8888b  ?88   d8P  d8P d8888b  88bd88b
#   `?88'  ?88 d8P' ?88 d88  d8P' d8P'd8b_,dP  88P'  `
#     88b  d8P 88b  d88 ?8b ,88b ,88' 88b     d88
#     888888P' `?8888P' `?888P'888P'  `?888P'd88'
#     88P'
#    d88
#   ?8P

# ~/.config/rofi/power.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays a Rofi menu with common power state options
# Dependencies : i3, rofi

# =================
# --- Execution ---
# =================

# Entries
entries="\
<span font_desc=\"DejaVuSansMono Nerd Font normal 14\"></span>      . . . . . . . . . .       lock
<span font_desc=\"DejaVuSansMono Nerd Font normal 14\">鈴</span>      . . . . . .      suspend
<span font_desc=\"DejaVuSansMono Nerd Font normal 14\">﫼</span>      . . . . . . . .     logout
<span font_desc=\"DejaVuSansMono Nerd Font normal 14\"></span>      . . . . . . .           restart
<span font_desc=\"DejaVuSansMono Nerd Font normal 14\"></span>      . . . .        shutdown"

# Initial Menu
typeset -r options="-dmenu -markup-rows -config ~/.config/rofi/power.rasi"
selection=$(printf "$entries" | rofi $options -width 10 -lines `wc -l <<< $entries`)

# Action Confirmation
[[ -z $selection ]] && exit 0
confirmation=$(printf '%s\n%s\n' "${selection##* }" "cancel" | rofi $options -width 10 -lines 2)

# Execute Action
case "$confirmation" in
  'lock'     ) light-locker-command -l ;;
  'suspend'  ) systemctl suspend  ;;
  'logout'   ) i3-msg exit        ;;
  'restart'  ) systemctl reboot   ;;
  'shutdown' ) systemctl poweroff ;;

  *) exit 0 ;;
esac
