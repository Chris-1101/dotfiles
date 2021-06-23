#!/usr/bin/env bash
#                                           d8P
#                                        d888888P
#    d8888b  88bd88b ?88   d8P ?88,.d88b,  ?88'
#   d8P' `P  88P'  ` d88   88  `?88'  ?88  88P
#   88b     d88      ?8(  d88    88b  d8P  88b
#   `?888P'd88'      `?88P'?8b   888888P'  `?8b
#                          )88   88P'
#                         ,d8P  d88
#                      `?888P' ?8P

# ~/.config/polybar/crypt.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays information about encrypted containers
# Dependencies : veracrypt

# =================
# --- Functions ---
# =================

function list_mounted
{
  veracrypt --text --list 2>/dev/null
}

function count_lines
{
  wc -l
}

# =================
# --- Execution ---
# =================

typeset -ir num_mounted=$(list_mounted | count_lines)

printf -- "Crypt  %%{T2}%%{T-}   $num_mounted"
