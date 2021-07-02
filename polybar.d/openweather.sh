#!/usr/bin/env bash
#                                                                             d8b
#                                                                         d8P  ?88
#                                                                      d888888P 88b
#    d8888b ?88,.d88b,  d8888b  88bd88b  ?88   d8P  d8P d8888b  d888b8b  ?88'   888888b   d8888b  88bd88b
#   d8P' ?88`?88'  ?88 d8b_,dP  88P' ?8b d88  d8P' d8P'd8b_,dP d8P' ?88  88P    88P `?8b d8b_,dP  88P'  `
#   88b  d88  88b  d8P 88b     d88   88P ?8b ,88b ,88' 88b     88b  ,88b 88b   d88   88P 88b     d88
#   `?8888P'  888888P' `?888P'd88'   88b `?888P'888P'  `?888P' `?88P'`88b`?8b d88'   88b `?888P'd88'
#             d88
#            88P'
#           ?8P

# ~/.config/polybar/openweather.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays hourly forecast
# Dependencies : curl, jq, secret-tool (GNOME)

# ===============
# --- Options ---
# ===============

# Set Day Time Hours
typeset -ir time_dawn=900    # 09:00 am
typeset -ir time_dusk=1800   # 06:00 pm

# Day Weather Icons
typeset -Ar day_icons=(
  ['colour']='#FFB52A'   # Colour to use for day-time icons
  ['clear']=''          # Clear weather icon

  ['210']=''   ['211']=''   ['212']=''   ['221']=''   # Thunderstorm
  ['200']=''   ['201']=''   ['202']=''                 # Thunderstorm With Rain
  ['230']=''   ['231']=''   ['232']=''                 # Thunderstorm With Drizzle
  ['300']=''   ['301']=''   ['302']=''                 # Drizzle
  ['310']=''   ['311']=''   ['312']=''                 # Drizzle Rain
  ['313']=''   ['314']=''   ['321']=''                 # Shower Rain and Drizzle
  ['500']=''   ['501']=''   ['502']=''                 # Rain (1)
  ['503']=''   ['504']=''   ['511']=''                 # Rain (2)
  ['520']=''   ['521']=''   ['522']=''   ['531']=''   # Shower Rain
  ['600']=''   ['601']=''   ['602']=''                 # Snow
  ['611']=''   ['612']=''   ['615']=''   ['616']=''   # Rain and Snow
  ['620']=''   ['621']=''   ['622']=''                 # Shower Snow
  ['701']=''   ['711']=''   ['721']=''   ['741']=''   # Mist, Smoke, Haze, Fog
  ['731']=''   ['751']=''   ['761']=''   ['762']=''   # Sand, Dust, Smog, Ash
  ['800']=''   ['903']=''   ['904']=''   ['951']=''   # Clear, Temperature
  ['801']=''   ['802']=''   ['803']=''   ['804']=''   # Cloudy and Overcast
  ['771']=''   ['781']=''   ['900']=''   ['905']=''   # Wind and Tornado
  ['901']=''   ['902']=''   ['962']=''                 # Hurricane
  ['952']=''   ['953']=''   ['954']=''   ['955']=''   # Breeze
  ['956']=''   ['957']='煮'   ['958']='煮'   ['959']='煮'   # Gale
  ['906']=''   ['960']=''   ['961']=''                 # Hail and Thunderstorm
)

# Night Weather Icons
typeset -Ar night_icons=(
  ['colour']='#05ADFF'   # Colour to use for night-time icons
  ['clear']='望'          # Clear weather icon

  ['210']=''   ['211']=''   ['212']=''   ['221']=''   # Thunderstorm
  ['200']=''   ['201']=''   ['202']=''                 # Thunderstorm With Rain
  ['230']=''   ['231']=''   ['232']=''                 # Thunderstorm With Drizzle
  ['300']=''   ['301']=''   ['302']=''                 # Drizzle
  ['310']=''   ['311']=''   ['312']=''                 # Drizzle Rain
  ['313']=''   ['314']=''   ['321']=''                 # Shower Rain and Drizzle
  ['500']=''   ['501']=''   ['502']=''                 # Rain (1)
  ['503']=''   ['504']=''   ['511']=''                 # Rain (2)
  ['520']=''   ['521']=''   ['522']=''   ['531']=''   # Shower Rain
  ['600']=''   ['601']=''   ['602']=''                 # Snow
  ['611']=''   ['612']=''   ['615']=''   ['616']=''   # Rain and Snow
  ['620']=''   ['621']=''   ['622']=''                 # Shower Snow
  ['701']=''   ['711']=''   ['721']=''   ['741']=''   # Mist, Smoke, Haze, Fog
  ['731']=''   ['751']=''   ['761']=''   ['762']=''   # Sand, Dust, Smog, Ash
  ['800']='望'   ['903']=''   ['904']='望'   ['951']='望'   # Clear, Temperature
  ['801']=''   ['802']=''   ['803']=''   ['804']=''   # Cloudy and Overcast
  ['771']=''   ['781']=''   ['900']=''   ['905']=''   # Wind and Tornado
  ['901']=''   ['902']=''   ['962']=''                 # Hurricane
  ['952']=''   ['953']=''   ['954']=''   ['955']=''   # Breeze
  ['956']=''   ['957']='煮'   ['958']='煮'   ['959']='煮'   # Gale
  ['906']=''   ['960']=''   ['961']=''                 # Hail and Thunderstorm
)

# Error Icon
typeset -r error_icon=''

# =================
# --- Functions ---
# =================

# Get Time
function get_time
{
  date +'%H%M'
}

# Get Icon Set Name
function get_icon_set
{
  local -ir time=10#$(get_time)

  if [[ $time -ge $time_dawn && $time -lt $time_dusk ]]; then
    printf 'day_icons'
  else
    printf 'night_icons'
  fi
}

# Get Keyring Entry
function get_secret
{
  secret-tool lookup name "$1"
}

# HTTP GET Request
function get_request
{
  local headers='-H "Accept:application/json" -H "Content-Type:application/json"'
  curl --silent $headers -X GET "$1"
}

# Check Response Status
function is_valid_response
{
  local -i status_code=$(printf "$res" | jq '.cod')
  local -i max_status=399 # Allow 100-399 codes

  test $status_code -le $max_status
}

# Retrieve Forecast ID
function get_forecast_id
{
  printf "$res" | jq '.weather[0].id'
}

# =================
# --- Execution ---
# =================

# Build HTTP Request
typeset -r api_key=$(get_secret 'openweather_apikey')
typeset -r city_id=$(get_secret 'openweather_cityid')
typeset -r url="https://api.openweathermap.org/data/2.5/weather?id=$city_id&appid=$api_key"

# Store Response
typeset -r res=$(get_request "$url")

# Get Icon for Forecast
if [[ $? -ne 0 || ! is_valid_response ]]; then
  # Refernce Error Icon For Bad Requests
  typeset -nr icon=error_icon
else
  # Refrence Day or Night Icon Set
  typeset -nr icons=$(get_icon_set)

  # Retrieve Icon for ID
  typeset -ir forecast_id=$(get_forecast_id)
  typeset icon=${icons[$forecast_id]}

  # Guard Against Unknown IDs
  [[ -z $icon ]] && icon=$error_icon
fi

# Output
# if [[ $icon == ${icons['clear']} ]]; then
  # Run Old Script When Clear
  # $(dirname $0)/time_icon.sh
# else
  printf '%%{F%s}%%{T10}%s%%{T-}%%{F-}  ' "${icons['colour']}" "$icon"
# fi
