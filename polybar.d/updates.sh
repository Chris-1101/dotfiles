#!/usr/bin/env bash
#                             d8b
#                  System     88P             d8P
#                            d88           d888888P
#   ?88   d8P?88,.d88b,  d888888   d888b8b   ?88'  d8888b .d888b,
#   d88   88 `?88'  ?88 d8P' ?88  d8P' ?88   88P  d8b_,dP ?8b,
#   ?8(  d88   88b  d8P 88b  ,88b 88b  ,88b  88b  88b       `?8b
#   `?88P'?8b  888888P' `?88P'`88b`?88P'`88b `?8b `?888P'`?888P'
#              88P'
#             d88      Polybar Module
#            ?8P

# ~/.config/polybar/updates.sh

# Author       : Chris-1101 @ GitHub
# Description  : List and count system updates
# Dependencies : aurutils, pacman-contrib

# ===============
# --- Options ---
# ===============

# Lockfile Location
typeset -r lockfile="/tmp/$(basename $0).lock"

# Timeout in Seconds
typeset -ir timeout=10

# ========================
# --- Helper Functions ---
# ========================

# Create Lockfile
function create_lockfile
{
  # Create lockfile
  touch $lockfile

  # Remove on Exit
  trap 'remove_lockfile' EXIT

  # Assign lockfile to first available file descriptor and store value in $fd
  exec {fd}<>$lockfile
}

# Remove Lockfile
function remove_lockfile
{
  [[ -f $lockfile ]] && rm $lockfile
  exec {fd}>&-
}

# Acquire Write Lock
function acquire_write_lock
{
  flock -w $timeout $fd
}

# ======================
# --- Main Functions ---
# ======================

# Official Repositories
function get_pkg_updates
{
  local cache_path=/tmp/updates_pkg
  /usr/bin/checkupdates 2> /dev/null | tee $cache_path
}

# Arch User Repositories
function get_aur_updates
{
  local cache_path=/tmp/updates_aur
  aur repo -u 2> /dev/null | tee $cache_path
}

# =================
# --- Execution ---
# =================

# Guard Against Parallel Execution
create_lockfile
acquire_write_lock || exit 1

# Retrieve & Count Updates
updates_pkg=$(get_pkg_updates | wc -l) || 0
updates_aur=$(get_aur_updates | wc -l) || 0

# Output
echo "${updates_pkg}  ${updates_aur}"
