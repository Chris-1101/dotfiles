#!/usr/bin/env bash
#                      d8,                                  d8b                       d8b
#                      `8P                                   ?88                       ?88
#                                                             88b                       88b
#   ?88,.d88b,  88bd88b 88b  88bd8b,d88b   d8888b     d8888b  888888b   d8888b  d8888b  888  d88'
#   `?88'  ?88  88P'  ` 88P  88P'`?8P'?8b d8b_,dP    d8P' `P  88P `?8b d8b_,dP d8P' `P  888bd8P'
#     88b  d8P d88     d88  d88  d88  88P 88b        88b     d88   88P 88b     88b     d88888b
#     888888P'd88'    d88' d88' d88'  88b `?888P'    `?888P'd88'   88b `?888P' `?888P'd88' `?88b,
#     88P'
#    d88
#   ?8P

# ~/.local/bin/prime-check

# ===============
# --- Options ---
# ===============

typeset -r script_name='prime-check'

# =================
# --- Functions ---
# =================

# Logger
source "$(dirname $0)/lib/logger.sh"

# =================
# --- Execution ---
# =================

status="$(optimus-manager --status)"

if [[ $? -ne 0 ]]; then
  error="$(grep -oP '(?<=ERROR: ).*' <<< "$status")"
  logger "$script_name" "Optimus Manager reported $error Executing prime-offload."
  /usr/bin/prime-offload
else
  logger "$script_name" 'Optimus Manager checks passed, no actions taken.'
fi
