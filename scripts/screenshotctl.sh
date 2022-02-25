#!/usr/bin/env bash
#                                                            d8b                                        d8b
#                               Screenshot Control Script     ?88                 d8P           d8P    88P
#                                                              88b             d888888P      d888888P d88
#    .d888b, d8888b  88bd88b d8888b  d8888b  88bd88b  .d888b,  888888b   d8888b  ?88'  d8888b  ?88'   888
#    ?8b,   d8P' `P  88P'  `d8b_,dP d8b_,dP  88P' ?8b ?8b,     88P `?8b d8P' ?88 88P  d8P' `P  88P    ?88
#      `?8b 88b     d88     88b     88b     d88   88P   `?8b  d88   88P 88b  d88 88b  88b      88b    88b
#   `?888P' `?888P'd88'     `?888P' `?888P'd88'   88b`?888P' d88'   88b `?8888P' `?8b `?888P'  `?8b    88b

# ~/.local/bin/screenshotctl

# Author       : Chris-1101 @ GitHub
# Description  : Centralises different ways of taking screenshots
# Dependencies : dunst, dunstify, scrot, secret-tool (GNOME), xclip

# =================
# --- Functions ---
# =================

# Notifications
function notify
{
  if [[ $# -lt 2 ]]; then
    local header='Screenshot Taken'
  else
    local header="$2"
  fi

  local urgency='normal'
  local icon='~/Pictures/Icons/picture.png'
  local -i id=65723

  dunstify -u "$urgency" "$header" "$1" -i "$icon" -r $id
}

# Generate 8 Char Hash
function get_random_hash
{
  local uuid_path='/proc/sys/kernel/random/uuid'
  local uuid=$(cat $uuid_path)
  printf ${uuid%%-*}
}

# Get Keyring Entry
function get_secret
{
  secret-tool lookup name "$1"
}

# ISO 8601 Timestamp
function get_timestamp
{
  date +'%Y%m%d-%H%M%S'
}

# =================
# --- Execution ---
# =================

# Positional Parameters
for i in $@; do
  case "$i" in
    -c | --clipboard)  options+="-e 'xclip -selection clipboard -target image/png -i \$f && rm \$f' " ;;
    -e | --encryption) crypt="/$(get_secret dataptr_mp)" ;;
    -f | --fullscreen) ;; # Allow it for readability
    -s | --selection)  options+='--select -f '; sleep 0.4 ;;   # sleep -> fix for 'pointer' issue

    *) printf '%s\n' "Unknown argument $i"; exit 1 ;;
  esac
done

# File Options
scrot_dir="$HOME/Pictures/Screenshots$crypt"
scrot_fmt="scrot-$(get_timestamp)-$(get_random_hash)"
scrot_ext='png'

# Screenshot Location
scrot_path="${scrot_dir}/${scrot_fmt}.${scrot_ext}"

# Parse & run command
eval "scrot $options \"$scrot_path\""

# Notify
if [[ $? -eq 0 ]]; then
  if [[ $options =~ 'xclip' ]]; then
    notify 'Copied to clipboard'
  else
    notify "$scrot_fmt.$scrot_ext"
  fi
elif [[ $options =~ '--select' ]]; then
  notify 'Selection aborted' 'Screenshot Control'
fi
