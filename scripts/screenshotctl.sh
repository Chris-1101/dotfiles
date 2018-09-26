#!/usr/bin/env bash
#                                                     __            __          __   __
#     __________________   ____   ____   ____   _____|  |__   _____/  |_ ______/  |_|  |
#    /  ___/  ___\_  __ \ / __ \ / __ \ /    \ /  ___/  |  \ /  _ \   __\  ___\   __\  |
#    \___ \\  \___|  | \/\  ___/\  ___/|   |  \\___ \|   Y  (  (_) )  | \  \___|  | |  |__
#   /____  >\___  >__|    \___  >\___  >___|  /____  >___|  /\____/|__|  \___  >__| |____/
#        \/     \/            \/     \/     \/     \/     \/                 \/

# install:set type=root path=/usr/bin/screenshotctl

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Take screenshots and guard against overwriting existing files
# Dependencies : scrot, dunstify

# ===========================
# ------- 𝙈𝙖𝙞𝙣 𝙎𝙘𝙧𝙞𝙥𝙩 -------
# ===========================
function take_screenshot
{
  local script_title="Screenshot Taken"
  local not_duration=7000
  local not_id=5571

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
    local file_name="${scrot}$scrot_ext"
  else
    local file_name="${scrot}_${iterator}$scrot_ext"
  fi

  scrot $file_name
  dunstify "$script_title" "$(basename $file_name)" -t $not_duration -r $not_id
}

take_screenshot
unset take_screenshot
