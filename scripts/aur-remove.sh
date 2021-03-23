#!/usr/bin/env bash

#    d888b8b  ?88   d8P  88bd88b      88bd88b d8888b  88bd8b,d88b   d8888b  ?88   d8P d8888b
#   d8P' ?88  d88   88   88P'  `      88P'  `d8b_,dP  88P'`?8P'?8b d8P' ?88 d88  d8P'd8b_,dP
#   88b  ,88b ?8(  d88  d88          d88     88b     d88  d88  88P 88b  d88 ?8b ,88' 88b
#   `?88P'`88b`?88P'?8bd88'         d88'     `?888P'd88' d88'  88b `?8888P' `?888P'  `?888P'

# ~/.local/bin/aur-remove

# Author       : Chris-1101 @ GitHub
# Description  : Removes specified package from local AUR pacman repository
# Dependencies : Arch-based distro (pacman, paccache, repo-remove), aurutils

# ===============
# --- Helpers ---
# ===============

# Logger
source "$(dirname $0)/lib/logger.sh"

# Info Logger
function info_log
{
  local -r script_name='aur-remove'
  local -r colour=$(tput setaf 2)
  local -r reset=$(tput sgr0)
  local -r dim=$(tput dim)

  logger "$script_name" "${dim}░░$reset ${colour}$1$reset"
}

# ==============
# --- Pacman ---
# ==============

# Check Pacman
function is_installed
{
  info_log "Checking pacman for '$1' installation"
  pacman -Qi "$1" > /dev/null 2>&1
}

# Uninstall Pkg
function uninstall
{
  info_log "Uninstalling $1"
  sudo pacman -Rns "$1"
}

# ===========
# --- AUR ---
# ===========

# Check AUR
function is_aur_pkg
{
  info_log "Checking local AUR repository for '$1' package"
  local aur_pkgs=$(aur repo -l aur)
  grep "$1" <<< "$aur_pkgs" > /dev/null
}

# Remove From AUR
function remove_from_aur
{
  local -r aur_repo_db=$(aur repo --path aur)
  local -r aur_repo_dir="${aur_repo_db%/*}"
  local -r aur_sync_dir="$HOME/.cache/aurutils/sync/$1"

  info_log "Removing $1 from AUR database"
  repo-remove "$aur_repo_db" "$1"

  info_log 'Clearing AUR cache'
  [[ -d $aur_sync_dir ]] && rm -rf "$aur_sync_dir" && printf '%s\n' "removed $aur_sync_dir"
  paccache --cachedir "$aur_repo_dir" --remove --keep 0 --verbose "$1"

  info_log 'Refreshing pacman databases'
  sudo pacman -Sy
}

# =================
# --- Execution ---
# =================

# Input Sanity Check
if [[ -z $1 ]]; then
  printf '%s\n' 'Please specify a package to be removed from the local AUR repository'
  exit 1
fi

# Remove Package from AUR
is_installed "$1" && uninstall "$1" || true
is_aur_pkg "$1" && remove_from_aur "$1" || true
