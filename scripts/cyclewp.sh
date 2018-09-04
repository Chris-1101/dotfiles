#!/usr/bin/env bash
#                        __         __      __
#    _____ ___ __  ____ |  |   ____/  \    /  \_____
#   /  ___|   |  |/ ___\|  |  / __ \   \/\/   /____ \
#   \  \___\___  \  \___|  |_\  ___/\        /|  |_) )
#    \___  > ____|\___  >____/\___  >\__/\  / |   __/
#        \/\/         \/          \/      \/  |__|

# install:set type=root path=/usr/bin/cyclewp

# Author       : Chris MB
# GitHub       : https://github.com/Chris-1101
# Description  : Cycle through images in a directory and set them as wallpaper
# Dependencies : feh

# ====================================
# ------- 𝙁𝙪𝙣𝙘𝙩𝙞𝙤𝙣　𝘿𝙚𝙛𝙞𝙣𝙞𝙩𝙞𝙤𝙣𝙨 -------
# ====================================
function set_next_wp
{
  # Verify directory
  if [[ -z $1 ]]; then
    printf "Please specify a directory\n"
    exit 1
  elif [[ ! -d $1 ]]; then
    printf "Invalid directory $1\n"
    exit 1
  fi

  # Setup globbing and cache
  local path_cache=$HOME/.cache/current_wp
  local path_filetypes="$1/*.png \
                        $1/*.jpg \
                        $1/*.jpeg"

  # Retrieve current wallpaper
  function get_current_wp
  {
    if [[ -f $path_cache ]]; then
      cat $path_cache
    else
      touch $path_cache
    fi
  }

  # Cycle wallpaper
  function set_next_wp
  {
    local -i first_index=0
    local -i last_index=$(( ${#wallpapers[@]} - 1 ))
    local -i next_index=$current_index
    local -i init_index

    if [[ $wp_cycleback = 'true' ]]; then
      (( next_index-- ))
      init_index=$last_index
    else
      (( next_index++ ))
      init_index=$first_index
    fi

    if [[ next_index -gt last_index ]]; then
      next_index=$init_index
    fi

    feh --bg-scale "${wallpapers[$next_index]}" 2> /dev/null
    echo "${wallpapers[$next_index]}" > "$path_cache"
  }

  # Initial index set higher than probable directory count
  # so set_next_wp() sets index to first in cycle
  local -i current_index=10000
  local -a wallpapers=()

  # Remember user's globbing settings
  local nullglob=$(shopt -p nullglob)
  shopt -s nullglob

  # Build indexed array
  for file in $path_filetypes; do
    wallpapers+=( "$file" )
  done

  # Restore user settings
  eval $nullglob

  # Guard against empty directories
  if [[ ${#wallpapers[@]} -eq 0 ]]; then
    printf "Could not find any image files (png, jpg, jpeg) in specified directory.\n"
    exit 1
  fi

  # Get current wallpaper path
  local current_wp=$(get_current_wp)

  # Find current wallpaper index
  for i in ${!wallpapers[@]}; do
    if [[ ${wallpapers[$i]} = $current_wp ]]; then
      current_index=$i
    fi
  done

  # --- Debug
  if [[ $wp_debug = 'true' ]]; then
    for i in ${!wallpapers[@]}; do
      printf "[$i]: ${wallpapers[$i]}\n"
    done
    printf ":: Current wallpaper: [$current_index]\n"
    return
  fi # ---

  set_next_wp
}

# Usage
function help
{
  local f_grn=$(tput setaf 2)
  local f_ylw=$(tput setaf 3)
  local f_clr=$(tput sgr0)

  printf "Usage: ${f_grn}cyclewp${f_clr} ${f_ylw}DIRECTORY${f_clr}\n"
  printf "       ${f_grn}cyclewp${f_clr} [${f_grn}-b${f_clr} ${f_ylw}DIRECTORY${f_clr}]\n"
  printf "       ${f_grn}cyclewp${f_clr} [${f_grn}-r${f_clr} ${f_ylw}DIRECTORY${f_clr}]\n"
  printf "       ${f_grn}cyclewp${f_clr} [${f_grn}-d${f_clr} ${f_ylw}DIRECTORY${f_clr}]\n"
  printf "       ${f_grn}cyclewp${f_clr} [${f_grn}-h${f_clr}]\n"
  printf "\n"
  printf "   ${f_grn}-b${f_clr}: reverse cycle order\n"
  printf "   ${f_grn}-r${f_clr}: randomise wallpaper selection\n"
  printf "   ${f_grn}-d${f_clr}: debug: print current wallpaper and those found in ${f_ylw}DIRECTORY${f_clr}\n"
  printf "   ${f_grn}-h${f_clr}: print these usage instructions\n"
}

# =======================================
# ------- 𝙋𝙖𝙧𝙖𝙢𝙚𝙩𝙚𝙧 𝙈𝙖𝙣𝙖𝙜𝙚𝙢𝙚𝙣𝙩 -------
# =======================================
while getopts ":dbhr:" opt; do
  case $opt in

    r)
      if [[ -d $OPTARG ]]; then
        feh --bg-scale "$OPTARG" -z 2> /dev/null
        exit 0
      else
        printf "Invalid argument passed to option -r: $OPTARG is not a directory"
        exit 1
      fi
      ;;

    d)
      wp_debug=true
      ;;

    b)
      wp_cycleback=true
      ;;

    h)
      help
      exit 0
      ;;

    :)
      printf "Option -$OPTARG requires a valid directory\n"
      exit 1
      ;;

    *)
      printf "Invalid option: -$OPTARG, run $(basename $0) -h for usage instructions\n"
      exit 1
      ;;

  esac
done

shift $(( OPTIND - 1 ))

set_next_wp "$1"
