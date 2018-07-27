#!/usr/bin/env bash
#                                                     __            __          __   __
#     ______ ___________   ____   ____   ____   _____|  |__   _____/  |_  _____/  |_|  |
#    /  ___// ___\_  __ \_/ __ \_/ __ \ /    \ /  ___/  |  \ /  _ \   __\/ ___\   __\  |
#    \___ \\  \___|  | \/\  ___/\  ___/|   |  \\___ \|   Y  (  (_) )  | \  \___|  | |  |__
#   /____  >\___  >__|    \___  >\___  >___|  /____  >___|  /\____/|__|  \___  >__| |____/
#        \/     \/            \/     \/     \/     \/     \/                 \/

#!!:/usr/bin/screenshotctl

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Take screenshots and guard against overwriting existing files
# Dependencies : scrot, dunstify

function file_name
{
  local date=$(date +%Y.%m.%d-%H%M)
  local scrot_dir=~/Pictures/Screenshots
  local scrot_ext=".png"
  local scrot=${scrot_dir}/${date}_scrot
  local iterator=1

  function scrot_exists
  {
    if [[ $iterator -eq 1 ]]; then
      test -e "${scrot}$scrot_ext"
    else
      test -e "${scrot}_${iterator}$scrot_ext"
    fi
  }

  while scrot_exists; do
    (( iterator++ ))
  done

  if [[ $iterator -eq 1 ]]; then
    echo "${scrot}$scrot_ext"
  else
    echo "${scrot}_${iterator}$scrot_ext"
  fi
}

file_name=$(file_name)

scrot $file_name -e 'mv $f ~/Pictures/Screenshots/'
dunstify "Screenshot Taken" "$(basename $file_name)" -t 7000 -r 5571
