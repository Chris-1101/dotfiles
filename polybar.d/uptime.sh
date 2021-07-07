#!/usr/bin/env bash
#                              d8,
#                         d8P  `8P
#                      d888888P
#   ?88   d8P?88,.d88b,  ?88'   88b  88bd8b,d88b   d8888b
#   d88   88 `?88'  ?88  88P    88P  88P'`?8P'?8b d8b_,dP
#   ?8(  d88   88b  d8P  88b   d88  d88  d88  88P 88b
#   `?88P'?8b  888888P'  `?8b d88' d88' d88'  88b `?888P'
#              88P'
#             d88    Polybar Module
#            ?8P

# ~/.config/polybar/uptime.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays system uptime
# Dependencies : - N/A

# =================
# --- Functions ---
# =================

# Timestamp Format
function format_time
{
  sed -e 's/up //' \
      -e 's/\ years\?,/y/' \
      -e 's/\ weeks\?,/w/' \
      -e 's/\ days\?,/d/' \
      -e 's/\ hours\?,\?/h/' \
      -e 's/\ minutes\?/m/'
}

# =================
# --- Execution ---
# =================

# Output
uptime --pretty | format_time
