#!/usr/bin/env bash
#                        __
#     ________ __  _____/  |_  ____  ______ ____   ____   ____
#    / ____/  |  \/  _ \   __\/ __ \/  ___// ___\_/ __ \ /    \
#   ( (_|  |  |  (  (_) )  | \  ___/\___ \/ /_/  >  ___/|   |  \
#    \__   |____/ \____/|__|  \___  >___  >___  / \___  >___|  /
#       |__|                      \/    \/(____/      \/     \/

# install:set type=root path=/usr/bin/quotesgen

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Randomly print quotes from a flat-file database
# Dependencies : bash >= 4.0 (mapfile)

# ====================================
# ------- 𝙁𝙪𝙣𝙘𝙩𝙞𝙤𝙣　𝘿𝙚𝙛𝙞𝙣𝙞𝙩𝙞𝙤𝙣𝙨 -------
# ====================================
function generate_quote
{
  # TODO move location to ~/.cache
  # Path to the quotes file, each line is assumed to be a separate quote
  local quotes_db=~/.dotfiles/scripts/QUOTES

  # Process the file, ignoring empty lines and comments (#)
  local quotes && mapfile -t quotes < <(grep -v -E '^$|^#.*$' "$quotes_db")

  # Count eligible lines in file
  local quotes_total=${#quotes[@]}

  # Start printing quotes
  if [[ -z $quotes_num ]]; then
    local quotes_rand=$(( RANDOM % $quotes_total ))
    eval echo "${quotes[$quotes_rand]}" $quotes_clr
  else
    # Guard against user asking for more quotes than are available
    if [[ $quotes_num -gt $quotes_total ]]; then
      quotes_num=$quotes_total
    fi

    for (( i = 0; i < $quotes_num; i++ )); do
      # Print a random quote
      local quotes_rand=$(( RANDOM % $quotes_total ))
      echo "${quotes[$quotes_rand]}"

      # Remove processed elements from array to avoid duplicates
      unset quotes[$quotes_rand]
      quotes=("${quotes[@]}")
      quotes_total=${#quotes[@]}
    done
  fi
}

function help
{
  local f_grn=$(tput setaf 2)
  local f_ylw=$(tput setaf 3)
  local f_clr=$(tput sgr0)

  echo "Usage: ${f_grn}quotegen${f_clr}"\
       "[${f_grn}-c${f_clr}]"\
       "[${f_grn}-n${f_clr} ${f_ylw}num${f_clr}]"\
       "[${f_grn}-h${f_clr}]"

  echo "   ${f_grn}-c${f_clr}: colour output"
  echo "   ${f_grn}-a${f_clr}: animate output, assumes ${f_grn}-c${f_clr}"
  echo "   ${f_grn}-n${f_clr}: number of quotes to print, defaults to 1"
  echo "   ${f_grn}-h${f_clr}: print these usage instructions"
}

# =======================================
# ------- 𝙋𝙖𝙧𝙖𝙢𝙚𝙩𝙚𝙧 𝙈𝙖𝙣𝙖𝙜𝙚𝙢𝙚𝙣𝙩 -------
# =======================================
while getopts ":hcan:" opt; do
  case $opt in
    c)
      quotes_clr='| lolcat'
      ;;
    a)
      quotes_clr='| lolcat -a -d 30 -s 30'
      ;;
    n)
      if [[ $OPTARG =~ [0-9]+ ]]; then
        quotes_num=$OPTARG
      else
        echo "Invalid argument passed to -n: ${OPTARG}. Must be an integral number."
        exit 1
      fi
      ;;
    h)
      help
      exit 0
      ;;
    :)
      echo "Option -$OPTARG requires an argument"
      exit 1
      ;;
    *)
      echo "Invalid option: -$OPTARG, run install.sh -h for usage instructions"
      exit 1
      ;;
  esac
done

generate_quote
