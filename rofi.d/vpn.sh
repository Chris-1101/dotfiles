#!/usr/bin/env bash

#   ?88   d8P ?88,.d88b,  88bd88b
#   d88  d8P' `?88'  ?88  88P' ?8b
#   ?8b ,88'    88b  d8P d88   88P
#   `?888P'     888888P'd88'   88b
#               88P'
#              d88
#             ?8P

# ~/.config/rofi/vpn.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays a Rofi menu to control VPN tunnels
# Dependencies : dunstify, nmcli, nordvpn, rofi, xdotool

# =================
# --- Functions ---
# =================

# Scan for Active Tunnels
function has_active_tunnel
{
  nmcli -t -f 'TYPE' connection show --active | grep -q 'tun'
}

# NordVPN Status
function has_nord_connection
{
  nordvpn status | grep -q 'Status: Connected'
}

# Saved VPN Connections
function get_vpn_connections
{
  nmcli -t -f 'NAME,TYPE' connection show | grep ':vpn'
}

# Name of Active VPN
function get_active_vpn
{
  nmcli -t -f 'NAME,TYPE' connection show --active | grep ':vpn' | sed 's/:vpn//g'
}

# Get NordVPN Favourites
function get_nord_pinned
{
  # Static
  local -a favs=('Hong Kong', 'Portugal', 'South Korea', 'Spain', 'United Kingdom' 'United States')
  local prefix='<span font_desc="DejaVuSansMono Nerd Font normal 12"></span>   '

  local tmp=$(printf "$prefix%s\n" "${favs[@]}")
  printf "$tmp\n%s" '<span font_desc="DejaVuSansMono Nerd Font normal 12"></span>   All Servers' | sed 's/,//g'
}

# Get All NordVPN Locations
function get_nord_countries
{
  local countries=$(nordvpn countries)
  local prefix='<span font_desc="DejaVuSansMono Nerd Font normal 12"><\/span>   '
  printf '%s\n' $countries | tail -n +3 | sort | sed -e 's/\r//g' -e 's/_/ /g' -e "s/^/$prefix/g" -e 's/,//g'
}

# Get Cursor Coords
function get_mouse_x
{
  xdotool getmouselocation | awk '{print $1}' | sed 's/x://g'
}

# Launch Rofi
function launcher
{
  local markup='<span font_desc="DejaVuSansMono Nerd Font normal 12"></span>'
  local -i width=$(( ($(wc -L <<< $1) - ${#markup}) / 2 + 1 ))
  local -i offset=$(( `get_mouse_x` - 50 ))
  local -i height=$(wc -l <<< "$1")
  [[ $height -gt 8 ]] && height=8

  local -r options="-dmenu -markup-rows -config ~/.config/rofi/vpn.rasi"
  rofi $options -lines $height -width $width <<< "$1" # -xoffset $offset
}

# Notifications
function notify
{
  local urgency='normal'
  local header='NordVPN'
  local icon='~/Pictures/Icons/sunrise.png'
  local -i id=84723

  dunstify -u "$urgency" "$header" "$1" -i "$icon" -r $id
}

# =================
# --- Execution ---
# =================

# Active VPN
if has_active_tunnel; then
  string='<span font_desc="DejaVuSansMono Nerd Font normal 12"></span>   Disconnect'
  disconnect=$(launcher "$string")

  if [[ -n $disconnect ]] && has_nord_connection; then
    nordvpn disconnect
  elif [[ -n $disconnect ]]; then
    vpn=$(get_active_vpn)
    nmcli connection down "$vpn"
  fi

  exit 0
fi

# Build Menu
vpn_connections="$(grep ':vpn' <<< `get_vpn_connections` | sed 's/:vpn//g')"
vpn_prefix='<span font_desc="DejaVuSansMono Nerd Font normal 12">爵<\/span>   '

connections=$'<span font_desc="DejaVuSansMono Nerd Font normal 12"></span>   NordVPN\n'
connections+=$(sed "s/^/$vpn_prefix/g" <<< "$vpn_connections")

selection=$(launcher "$connections")
selection="${selection##*>   }"

# Handle Selection
case "$selection" in
  '')
    exit 0
    ;;

  'NordVPN')
    favourites=$(get_nord_pinned)
    country=$(launcher "$favourites")

    if [[ ${country##*>   } == 'All Servers' ]]; then
      countries=$(get_nord_countries)
      country=$(launcher "$countries")
    fi

    country=$(sed 's/ /_/g' <<< "${country##*>   }")
    [[ -n $country ]] && nordvpn connect "$country" || notify 'Failed to connect'
    ;;

  *)
    nmcli connection up "$selection"
    ;;
esac
