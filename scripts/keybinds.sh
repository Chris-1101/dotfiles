#!/usr/bin/env bash

#   d8b                          d8b        d8,                  d8b
#    ?88                          ?88       `8P                 88P
#     88b                          88b                         d88
#     888  d88' d8888b ?88   d8P   888888b   88b 88bd88b   d888888   .d888b,
#     888bd8P' d8b_,dP d88   88    88P `?8b  88P 88P' ?8b d8P' ?88   ?8b,
#    d88888b   88b     ?8(  d88   d88,  d88 d88 d88   88P 88b  ,88b    `?8b
#   d88' `?88b,`?888P' `?88P'?8b d88'`?88P'd88'd88'   88b `?88P'`88b`?888P'
#                             )88
#                            ,d8P
#                         `?888P'

# ~/.local/bin/keybinds

# Author       : Chris-1101 @ GitHub
# Description  : Prints a descriptive list of OS keybinds
# Dependencies : tput

# ===============
# --- Options ---
# ===============

typeset -r term_title='Keybinds'
typeset -ir term_w=169
typeset -ir term_h=40
typeset -ir term_x=26
typeset -ir term_y=72

# =================
# --- Functions ---
# =================

function hide_cursor
{
  tput civis
}

function show_cursor
{
  tput cnorm
}

function pause_term
{
  read -n1 -rs   # Press any key to exit
}

function repeat_char_n_times
{
  local -r char=$1
  local -ir num=$2

  printf -- "$char%.0s" {$(seq 1 $num)}
}

function launch_terminal
{
  alacritty \
    -o window.dimensions.columns=$term_w \
    -o window.dimensions.lines=$term_h \
    -o window.position.x=$term_x \
    -o window.position.y=$term_y \
    --class=float-override \
    -t "$term_title" \
    -e $SHELL \
    -c "$0 --content"
}

# Print Colour
function printc
{
  local colour=''
  local reset=$(tput sgr0)   # Select Graphical Rendition 0

  case $1 in
    'NINJA'   ) ;&   # fallthrough
    'BLACK'   ) colour=$(tput setaf 0) ;;
    'RED'     ) colour=$(tput setaf 1) ;;
    'GREEN'   ) colour=$(tput setaf 2) ;;
    'YELLOW'  ) colour=$(tput setaf 3) ;;
    'BLUE'    ) colour=$(tput setaf 4) ;;
    'MAGENTA' ) colour=$(tput setaf 5) ;;
    'CYAN'    ) colour=$(tput setaf 6) ;;

    * ) colour=$(tput setaf 7) ;;
  esac

  printf '%s' "$colour" "$2" "$reset" $'\n'
}

function print_title
{
  # Width
  local -i w_title=${#1}
  local -i w_padding=3 # each side
  local -i w_terminal=$(tput cols)
  local -i w_others=$(expr length '╣[  ]╠')
  local -i w_section=$(( (w_terminal - w_padding * 2 - w_title - w_others) / 2 ))

  # Parity
  local -i p_terminal=$(( w_terminal % 2 ))
  local -i p_title=$(( w_title % 2 ))

  # Character
  local -r c_section='═'
  local -r c_stop_lf='╣['
  local -r c_stop_rt=']╠'

  # String
  local -r s_padding=$(repeat_char_n_times ' ' $w_padding)
  local -r s_section=$(repeat_char_n_times "$c_section" $w_section)
  [[ $p_terminal -ne $p_title ]] && local -r s_extra=$c_section || true

  # Output
  local -r o_title=$(printc CYAN "$1")
  local -r o_left=$(printf '%s' "$s_padding" "$s_section" "$c_stop_lf" | lolcat -tfF 0.06 -S 0652)
  local -r o_right=$(printf '%s' "$c_stop_rt" "$s_section" "$s_extra" | lolcat -tfF 0.06 -S 2874)
  printf '%s' "$o_left" " $o_title " "$o_right" $'\n'
}

function print_separator
{
  local -ir w_term=$(tput cols)
  local -ir w_padding=3

  local -r separator=$(repeat_char_n_times '═' $(( w_term - w_padding * 2 )))
  local -r padding=$(repeat_char_n_times ' ' $w_padding)
  printf "$padding$separator" | lolcat -tF 0.05 -S 0662
}

function display_topbar
{
  ueberzug layer --parser bash 0< <(
    typeset -Ap add_command=([action]='add' [identifier]='left' [x]=3 [y]=8 [path]="$HOME/Pictures/arch_topbar_lf.png")
    typeset -Ap add_command=([action]='add' [identifier]='right' [x]=96 [y]=8 [path]="$HOME/Pictures/arch_topbar_rt.png")
    pause_term
  )
}

# =================
# --- Execution ---
# =================

case "$1" in
  -c | --content ) ;; # continue
  '' ) launch_terminal && exit $? ;;
  * ) echo "Unknown option $1" && exit 1
esac

# ==============
# --- Legend ---   NOTE: things get messy from here on
# ==============

# Header
printf $'\n'
print_title 'Legend'
printf $'\n'

# Legend
printf '    '
printf  "$(printc GREEN %s)  %s         " \
  '' 'Super' \
  'וּ' 'Shift' \
  'דּ' 'Control' \
  'הּ' 'Alt' \
  '' 'Alt Gr' \
  '' 'Tab' \
  '·' 'Space' \
  '' 'Enter' \
  '' 'Delete'
printf  "$(printc GREEN %s)  %s" \
  '尿' $'\b0-9'
printf $'\n'
printf $'\n'

# ====================
# --- Top Bar Info ---
# ====================

# Header
printf $'\n'
print_title 'Top Bar Info'
repeat_char_n_times $'\n' 5   # Spacer for ueberzug images

# Top Bar Info: Left 01
printf '    '
printf "$(printc BLUE %s)  %s  $(printc GREEN "%s")          " \
  '' 'OS Menu' ' הּ A' \
  '' 'Sensors' ' הּ S' \
  '' 'Fn Lock' ' `  ' \
  '直' 'WiFi' '     ' \
  '' 'Overflow Menu' '     '
printf "$(printc BLUE %s)  %s  $(printc GREEN "%s")" \
  '' 'Microphone' ' הּ M'
printf $'\n'

# Top Bar Info: Left 02
printf '    '
printf "$(printc BLUE %s)  %s  $(printc GREEN "%s")          " \
  ' ' '       ' '     ' \
  '' 'Updates' ' הּ U' \
  ''  'Blueooth' ' הּ B' \
  '旅' 'VPN ' ' הּ V' \
  '' 'Airplane Mode' ' הּ X'
printf "$(printc BLUE %s)  %s  $(printc GREEN "%s")" \
  'ﳶ' 'Touchpad  ' ' הּ T'
printf $'\n'

# Spacer
printf $'\n'

# Top Bar Info: Right 01
printf '    '
printf "$(printc BLUE %s)  %s  $(printc GREEN "%s")       " \
  '' 'Caffeine' '     ' \
  '  ' 'Screen Level' '     ' \
  $'\b\b墳' $'\bVolume Level' '     ' \
  $'\b' 'Battery Level' '     ' \
  $'\b\b\b\b\bﮤ' 'Battery Time' '     '
printf "$(printc BLUE %s)  %s  $(printc GREEN "%s")" \
  '    嗀' $'\bWeather' '     '
printf $'\n'

# Top Bar Info: Right 02
printf '    '
printf "$(printc BLUE %s)  %s  $(printc GREEN "%s")       " \
  '·' 'Calendar' ' הּ C' \
  ' ' '            ' '     ' \
  ' ' '            ' '     ' \
  ' ' '             ' '     ' \
  $'\b\b\b\b\b\bﮣ' 'Charging Time' '     '
printf "$(printc BLUE %s)  %s  $(printc GREEN "%s")" \
  '   ' 'Power Menu' ' הּ ␛'
printf $'\n'
printf $'\n'

# =============================
# --- Function & Media Keys ---
# =============================

# Header
printf $'\n'
print_title 'Function & Media Keys'
printf $'\n'

# Fn Keys 01
printf '    '
printf "$(printc GREEN %s)  %s           " \
  'F1' 'Mute Toggle' \
  'F3' 'Volume     ' \
  'F5' 'Night Mode' \
  'F7' 'Day Mode       ' \
  ' F9' '  Brightness '
printf "$(printc GREEN %s)  %s" \
  'F11' '  Backlight '
printf $'\n'

# Fn Keys 02
printf '    '
printf "$(printc GREEN %s)  %s           " \
  'F2' 'Volume    ' \
  'F4' 'Close Window' \
  'F6' 'Play/Pause' \
  'F8' '  Brightness ' \
  'F10' '  Backlight  '
printf "$(printc GREEN %s)  %s" \
  'F12' 'Print Screen'
printf $'\n'
printf $'\n'

# ======================
# --- Window Manager ---
# ======================

# Header
printf $'\n'
print_title 'Window Manager'
printf $'\n'

# Window Manager 01
printf '    '
printf "$(printc GREEN %s)  %s          " \
  ' '   'Focus ' \
  ' וּ ' 'Move ' \
  '   ' 'Next Workspace' \
  ' E'   'Layout: Split ' \
  '   ' 'Terminal         '
printf "$(printc GREEN %s)  %s\n" \
  $'\b\b F' 'Toggle Fullscreen'

# Window Manager 02
printf '    '
printf "$(printc GREEN %s)  %s          " \
  ' '   'Focus ' \
  ' וּ ' 'Move ' \
  ' וּ ' 'Prev Workspace' \
  ' W'   'Layout: Tabbed' \
  ' וּ ' 'Floating Terminal'
printf "$(printc GREEN %s)  %s\n" \
  $'\b\b T' 'Toggle Translucency'

# Window Manager 03
printf '    '
printf "$(printc GREEN %s)  %s          " \
  ' '   'Focus ' \
  ' וּ ' 'Move ' \
  ' דּ ' 'Last Workspace'
printf "$(printc GREEN %s)  %s\n" \
  ' S' 'Layout: Stacked'

# Window Manager 04
printf '    '
printf "$(printc GREEN %s)  %s          " \
  ' '   'Focus ' \
  ' וּ ' 'Move ' \
  ' 尿 '  'Switch to Workspace' \
  $'\b\b\b\b\b H' 'Tile: Horizontal' \
  $'\b\b וּ Q' 'Close Window   '
printf "$(printc GREEN %s)  %s\n" \
  ' וּ C' 'Reload Config'

# Window Manager 05
printf '    '
printf "$(printc GREEN %s)  %s          " \
  ' ·' 'Focus Float' \
  $'\b\b\b\b וּ ·' 'Dock/Float' \
  $'\b\b\b\b וּ 尿' $'\bMove to Workspace ' \
  $'\b\b\b\b V' 'Tile: Vertical' \
  ' D  ' 'Run Programme    '
printf "$(printc GREEN %s)  %s\n" \
  $'\b\b וּ R' 'Restart i3'

# Window Manager 06
printf '    '
printf "$(printc GREEN %s)  %s          " \
  ' /' 'Scratchpad' \
  $'\b\b\b וּ /' 'Move to Scratchpad' \
  '     ' '  ' \
  '     ' '            ' \
  '     ' '               '
printf "$(printc GREEN %s)  %s\n" \
  ' וּ E' 'Exit i3'

#  A     Focus Parent

# =============
# --- Other ---
# =============

# Header
printf $'\n'
print_title 'Other'
printf $'\n'

# Other
printf '    '
printf "$(printc GREEN %s)  %s                                    " \
  ' ' 'Toggle Screen Backlight'
printf "$(printc GREEN %s)  %s\n" \
  ' ·' 'Toggle Keyboard Backlight'
printf $'\n'

# =============
# --- Final ---
# =============

print_separator
hide_cursor
display_topbar
show_cursor
