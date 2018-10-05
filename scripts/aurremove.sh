#!/usr/bin/env bash
#   _____   __ ________________   ____   _____   _______  ___ ____
#   \__  \ |  |  \_  __ \_  __ \ / __ \ /     \ /  _ \  \/  // __ \
#    / __ \|  |  /|  | \/|  | \/\  ___/|  Y Y  (  (_) )    /\  ___/
#   (____  /____/ |__|   |__|    \___  >__|_|  /\____/ \__/  \___  >
#        \/                          \/      \/                 \/
#
# install:set type=root path=/usr/bin/aurremove

# Author       : Chris MacBain
# GitHub       : https://github.com/Chris-1101
# Description  : Uninstall from local AUR repository
# Dependencies : tput

# ==================================
# ------- 𝙁𝙤𝙧𝙢𝙖𝙩 𝘿𝙚𝙛𝙞𝙣𝙞𝙩𝙞𝙤𝙣𝙨 -------
# ==================================
f_bld=$(tput bold)
f_blk=$(tput setaf 0)
f_red=$(tput setaf 1)
f_grn=$(tput setaf 2)
f_ylw=$(tput setaf 3)
f_blu=$(tput setaf 4)
f_mag=$(tput setaf 5)
f_cyn=$(tput setaf 6)
f_wht=$(tput setaf 7)
f_rst=$(tput sgr0)

# ====================================
# ------- 𝙁𝙪𝙣𝙘𝙩𝙞𝙤𝙣　𝘿𝙚𝙛𝙞𝙣𝙞𝙩𝙞𝙤𝙣𝙨 -------
# ====================================
# Print Notice
function printn
{
  printf "${f_blu}::${f_rst} ${f_bld}$@${f_rst}\n"
}

# Print Alert
function printa
{
  printf "${f_grn}==>${f_rst} ${f_bld}$@${f_rst}\n"
}

function main
{
  # Guard against empty input
  if [[ -z $1 ]]; then
    printf "Please specify a package name."
    exit 1
  fi

  # Guard against invalid package names
  if [[ ! $(pacman -Qi $1 2> /dev/null) ]]; then
    printf "Package $1 doesn't exist."
    exit 1
  fi

  # Prompt user for confirmation
  read -p "${f_blu}::${f_rst} ${f_bld}Are you sure you want to remove $1 and all its config? [y/N]${f_rst} "

  # Begin uninstallation
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Uninstall from pacman
    printa "Preparing to uninstall $1..."
    sudo pacman -Rns $1
    printn "Uninstallation successful"
    sleep 1

    # Update local pacman repository (AUR)
    printa "Updating local AUR repository"
    find /var/cache/pacman/ -name '*.db.tar' -execdir repo-remove {} $1 \;
    printn "Repository AUR successfully updated"
    sleep 1

    # Remove cached packages
    printa "Removing cached packages"
    sudo rm -rf /var/cache/pacman/aur/$1*
    printn "Cached packages removed"
    sleep 1

    # Refresh pacman databases
    printa "Refreshing pacman databases"
    sudo pacman -Syu
    printn "All done, $1 is history!"
  fi
}

main "$@"
