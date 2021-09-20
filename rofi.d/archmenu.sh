# #!/usr/bin/env bash
#                             d8b
#                              ?88
#                               88b
#    d888b8b    88bd88b d8888b  888888b   88bd8b,d88b   d8888b  88bd88b  ?88   d8P
#   d8P' ?88    88P'  `d8P' `P  88P `?8b  88P'`?8P'?8b d8b_,dP  88P' ?8b d88   88
#   88b  ,88b  d88     88b     d88   88P d88  d88  88P 88b     d88   88P ?8(  d88
#   `?88P'`88bd88'     `?888P'd88'   88bd88' d88'  88b `?888P'd88'   88b `?88P'?8b

# ~/.config/rofi/archmenu.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays a Rofi menu with a list of useful keybinds
# Dependencies : rofi, pcregrep

# ===============
# --- Options ---
# ===============

typeset -r config="-config ~/.config/rofi/archmenu.rasi"
typeset -r options="-dmenu -markup-rows $config"

# ===============
# --- Content ---
# ===============

# Width of Each Menu - NOTE on width: padding not taken into account + using variable width font
typeset -Ar content_width=( ['Base']=8   ['Code']=10   ['Security']=8   ['System']=8   ['Utility']=9 )

# Entries for Each Menu
typeset -Ar content=(   # NOTE: to preserve spaces in names without changing IFS, EN spaces » « (U+2002) are being used
  ['Base']=',Keybinds ,Code,41, ,Security,21, ,System,28, ,Utility,37, ,Atom ,Files ,Firefox ,Mailspring ,Spotify ,Steam'
  ['Code']=',Code,80, ,Beekeeper Studio ,GitKraken ,IntelliJ ,Lepton ,Postman 聆,Slack'
  ['Security']=',Security,21, ,1Password ,Keeper 刺,TeamViewer ,VeraCrypt'
  ['System']=',System,28, ,Disks ,Settings'
  ['Utility']=',Utility,56, ,Calculator ,D-conf Editor ,GPick'
)

# Executable Paths
typeset -Ar exec_path=(
  ['1Password']=/usr/bin/1password
  ['Atom']=/usr/bin/atom
  ['Beekeeper']=/usr/bin/beekeeper-studio
  ['Calculator']=/usr/bin/gnome-calculator
  ['D-conf']=/usr/bin/dconf-editor
  ['Disks']=/usr/bin/gnome-disks
  ['Files']=/usr/bin/nautilus
  ['Firefox']=/usr/bin/firefox
  ['GitKraken']=/usr/bin/gitkraken
  ['GPick']=/usr/bin/gpick
  ['IntelliJ']=/usr/bin/idea
  ['Keeper']=/usr/bin/keeperpasswordmanager
  ['Keybinds']=~/.local/bin/keybinds
  ['Lepton']=/usr/bin/lepton-snippet-manager
  ['Mailspring']=/usr/bin/mailspring
  ['Postman']=/usr/bin/postman
  ['Settings']=/usr/bin/gnome-control-center
  ['Slack']=/usr/bin/slack
  ['Spotify']=/usr/bin/spotify
  ['Steam']=/usr/bin/steam
  ['TeamViewer']=/usr/bin/teamviewer
  ['VeraCrypt']=/usr/bin/veracrypt
)

# =================
# --- Functions ---
# =================

function repeat_char_n_times
{
  local -r char=$1
  local -ir num=$2
  printf -- "$char%.0s" {$(seq 1 $num)}
}

function build_menu_from_content
{
  local -ar entries=($1)
  local -r hair_space=' '   # NOTE: Codepoint U+200A (not a regular ASCII space)
  local -r typeface='DejaVuSansMono Nerd Font normal'
  local -r typesize=12
  local -r lf=$'\n'
  local menu=''

  for entry in ${entries[@]}; do
    components=(${entry//,/ })
    icon="${components[0]}"
    name="${components[1]}"
    size="${components[2]}"
    trail="${components[3]}"

    case "$icon" in
      '' ) type='folder' ;;
      '' ) type='back'   ;;
      *   ) type='exec'   ;;
    esac

    [[ -n $size ]] && suffix="$(repeat_char_n_times "$hair_space" $size)$trail" || suffix=''
    menu+="<span lang=\"$type\" font_desc=\"$typeface $typesize\">$icon</span>     $name$suffix$lf"
  done

  printf "$menu"
  unset components icon name size trail type suffix menu
}

function rofi_launcher
{
  local -r entries="$1"
  local -ir lines="$(wc -l <<< "$entries")"
  local -ir width=$2

  printf "$entries" | rofi $options -lines $lines -width $width
}

function extract_choice
{
  local -r pattern="(?<=lang=\")(\w*)(?=\")(?:.*)(?<=span>)(?:\s*)([\w\-]*)"
  pcregrep --om-separator=' ' -o1 -o2 "$pattern"
}

# =================
# --- Execution ---
# =================

# Initial Menu
selection='Base'

# Cycle Menus
while true; do
  width=${content_width[$selection]}
  entries=$(build_menu_from_content "${content[$selection]}")
  choice=($(rofi_launcher "$entries" "$width" | extract_choice))

  [[ ${choice[0]} == 'back' ]] && selection='Base' || selection=${choice[1]}
  [[ -z ${choice[0]} || ${choice[0]} == 'exec' ]] && break
done

# Execute Selection
[[ -n $selection ]] && eval "${exec_path[$selection]}" || true
