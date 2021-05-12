#!/usr/bin/env bash

#   ?88   d8P ?88,.d88b,  88bd88b
#   d88  d8P' `?88'  ?88  88P' ?8b
#   ?8b ,88'    88b  d8P d88   88P
#   `?888P'     888888P'd88'   88b
#               88P'
#              d88     Polybar
#             ?8P     Module

# ~/.config/polybar/vpn.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays currently active VPN tunnels
# Trigger      : /etc/NetworkManager/dispatcher.d/polybar-hook.sh
# Dependencies : nmcli, nordvpn, dispatcher script

# =========================
# --- NordVPN Countries ---
# =========================

# Country Codes
declare -A countries=(
  ['Albania']='AL'       ['Argentina']='AR'         ['Australia']='AU'
  ['Austria']='AU'       ['Belgium']='BE'           ['Bosnia and Herzegovina']='BA'
  ['Brazil']='BR'        ['Bulgaria']='BG'          ['Canada']='CA'
  ['Chile']='CL'         ['Costa Rica']='CR'        ['Croatia']='HR'
  ['Cyprus']='CY'        ['Czech Republic']='CZ'    ['Denmark']='DK'
  ['Estonia']='EE'       ['Finland']='FI'           ['France']='FR'
  ['Georgia']='GE'       ['Germany']='DE'           ['Greece']='GR'
  ['Hong Kong']='HK'     ['Hungary']='HU'           ['Iceland']='IS'
  ['India']='IN'         ['Indonesia']='ID'         ['Ireland']='IE'
  ['Israel']='IL'        ['Italy']='IT'             ['Japan']='JP'
  ['Latvia']='LV'        ['Luxembourg']='LU'        ['Malaysia']='MY'
  ['Mexico']='MX'        ['Moldova']='MD'           ['Netherlands']='NL'
  ['New Zealand']='NZ'   ['North Macedonia']='MK'   ['Norway']='NO'
  ['Poland']='PL'        ['Portugal']='PT'          ['Romania']='RO'
  ['Serbia']='RS'        ['Singapore']='SG'         ['Slovakia']='SK'
  ['Slovenia']='SI'      ['South Africa']='ZA'      ['South Korea']='KR'
  ['Spain']='ES'         ['Sweden']='SE'            ['Switzerland']='CH'
  ['Taiwan']='TW'        ['Thailand']='TH'          ['Turkey']='TR'
  ['Ukraine']='UA'       ['United Kingdom']='UK'    ['United States']='US'
  ['Vietnam']='VN'
)

# =================
# --- Functions ---
# =================

# Scan for VPN Tunnels
function has_active_tunnel
{
  local fields='TYPE'
  nmcli -t -f "$fields" connection show --active | grep -q 'tun'
  # Match this separately, purely on type, to avoid matching 'tun' in connection names
}

# Get VPN Type
function get_vpn_type
{
  local pattern='.*(?=:tun)' # Positive Look-ahead
  nmcli -t -f NAME,TYPE connection show --active | grep -oP "$pattern"
}

# Get VPN Name
function get_vpn_name
{
  local pattern='.*(?=:vpn)' # Positive Look-ahead
  nmcli -t -f NAME,TYPE connection show --active | grep -oP "$pattern"
}

# Get NordVPN Country
function get_nordvpn_country
{
  local country=$(nordvpn status | grep -e 'Country:' | cut -f 1 -d ' ' --complement)
  local code="${countries[$country]}"

  [[ -z $code ]] && code='??'
  echo "$code"
}

# =================
# --- Execution ---
# =================

if has_active_tunnel; then
  name=$(get_vpn_name)

  if [[ -z $name ]]; then
    name="$(get_nordvpn_country)"   # Assume NordVPN
  fi

  printf "%%{T4}%%{F#00DA90}旅 %%{F-}%%{T-}%%{T5} ${name}%%{T-}"
else
  printf '%%{T4}%%{F#FFB52A}旅%%{F-}%%{T-}'
fi
