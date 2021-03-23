#!/usr/bin/env bash

#    d888b8b  ?88   d8P  88bd88b     d888b8b   d8888b
#   d8P' ?88  d88   88   88P'  `    d8P'  ?88 d8P' `P
#   88b  ,88b ?8(  d88  d88         88b  ,88b 88b
#   `?88P'`88b`?88P'?8bd88'         `?88P'`88b`?888P'
#                                          )88
#                                         ,88P
#   ~/.local/bin/aur-gc               `?8888P

# Author       : Chris-1101 @ GitHub
# Description  : Garbage collection script for aur-utils sync directory
# Dependencies : Arch-based distro (pacman, paccache, repo-remove), aurutils

# ===============
# --- Options ---
# ===============

typeset -r aur_sync_dir="$HOME/.cache/aurutils/sync"   # Build Cache Directory

# ===============
# --- Helpers ---
# ===============

# Logger
source "$(dirname $0)/lib/logger.sh"

# Info Logger
function info_log
{
  local -r script_name='aur-gc'
  local -r colour=$(tput setaf 2)
  local -r reset=$(tput sgr0)
  local -r dim=$(tput dim)

  logger "$script_name" "${dim}░░$reset ${colour}$1$reset"
}

# ================
# --- Clean Up ---
# ================

# Git Clean Build Dirs
function clean_sync_dir
{
  local -r name_pattern='.git'
  local -r cmd='git clean -xf'

  info_log 'Cleaning build cache directories'
  find $aur_sync_dir -name $name_pattern -execdir $cmd \;
}

# PKGBUILD Checks
function check_pkgbuild
{
  info_log 'Scanning AUR sync directories for missing PKGBUILD files'
  for dir in "$aur_sync_dir"/*; do
    [[ -f $dir/PKGBUILD ]] || printf -v list '%s\n' "$dir"
  done

  if [[ -n $list ]]; then
    info_log 'The following directories are missing a PKGBUILD file:'
    printf '%s\n' "${list::-1}"
    info_log 'Consider investigating and/or deleting them'
  fi
}

# =================
# --- Execution ---
# =================

clean_sync_dir
check_pkgbuild
