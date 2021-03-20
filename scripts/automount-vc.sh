#!/usr/bin/env bash

#        VeraCrypt       d8P                                                      d8P
#                     d888888P                                                 d888888P
#    d888b8b  ?88   d8P ?88'  d8888b   88bd8b,d88b   d8888b  ?88   d8P  88bd88b  ?88'
#   d8P' ?88  d88   88  88P  d8P' ?88  88P'`?8P'?8b d8P' ?88 d88   88   88P' ?8b 88P
#   88b  ,88b ?8(  d88  88b  88b  d88 d88  d88  88P 88b  d88 ?8(  d88  d88   88P 88b
#   `?88P'`88b`?88P'?8b `?8b `?8888P'd88' d88'  88b `?8888P' `?88P'?8bd88'   88b `?8b

# ~/.local/bin/automount-vc

# Author       : Chris-1101 @ GitHub
# Description  : Auto-mounts select encrypted containers at boot
# Dependencies : secret-tool (GNOME), veracrypt

# ===============
# --- Volumes ---
# ===============

typeset -A volumes=(
  ['/data/Crypts/DataPTR.vol']='/mnt/dataptr'
  ['/data/Crypts/DataDCS.vol']='/mnt/datadcs'
)

# ===================
# --- Environment ---
# ===================

# D-Bus Session
export DISPLAY=:0
export XAUTHORITY=$HOME/.Xauthority
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID/bus"

# Script Name
typeset -r script_name='automount-vc'

# =================
# --- Functions ---
# =================

# Get Password
function get_secret
{
  zenity --password --title='Decryption Key'

  # secret-tool lookup name "$1"
}

# System Logger
source "$(dirname $0)/lib/logger.sh"

# Old Logger
function sys_log
{
  local name='automount-vc'
  systemd-cat -p info -t "$name"
}

# Check Mounted Volumes
function has_mounted_volumes
{
  local -ir num_mounted=$(veracrypt --text --list 2>/dev/null | wc -l)

  test $num_mounted -gt 0
}

# Check Permissions
function check_volume_rw
{
  local vol_props=$(veracrypt -t --volume-properties "$1")
  grep -q 'Read-Only: Yes' <<< "$vol_props"
}

# Notify Limited Permissions
function notify_volume_ro
{
  zenity --warning --text="Volume $1 mounted as read-only." --ellipsize
}

# Polybar hook
function update_polybar
{
  ~/.local/bin/hookctl --polybar 'bottom' 'fs-crypt' 1
}

# Mount Volume
function mount_vol
{
  local -r secret=$1
  local -r volume=$2
  local -r mount_point=$3
  local -r hash_algorithm='Whirlpool'

  sudo veracrypt --pim=0 --protect-hidden='no' -k '' -p "$secret" --hash "$hash_algorithm" "$volume" "$mount_point"

  # cryptsetup open --type tcrypt --veracrypt "$volume" dataptr --key-file /dev/stdin < <(get_secret dataptr)
  # mount /dev/mapper/dataptr "$mount_point"
}

# Mount All Volumes
function mount_vols
{
  local -r secret=$(get_secret)
  [[ -z $secret ]] && exit 0

  logger "$script_name" 'Mounting encrypted volumes...'

  for volume in ${!volumes[@]}; do
    local mount_point=${volumes[$volume]}
    mount_vol "$secret" "$volume" "$mount_point"
    check_volume_rw "$mount_point" && notify_volume_ro "${mount_point##*/}" || true
  done
}

# Dismount All Volumes
function dismount_vols
{
  logger "$script_name" 'Dismounting encrypted volumes...'

  sudo veracrypt -t -d

  # umount /dev/mapper/dataptr
  # cryptsetup close /dev/mapper/dataptr
}

# =================
# --- Execution ---
# =================

# Options
case "$1" in
  -m | --mount    ) mount_vols ;;
  -d | --dismount ) dismount_vols ;;
  -t | --toggle   ) has_mounted_volumes && dismount_vols || mount_vols ;;
esac

# Polybar Hook
update_polybar
