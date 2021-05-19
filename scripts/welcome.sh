#!/usr/bin/env bash
#                           d8b
#                          88P
#                         d88
#   ?88   d8P  d8P d8888b 888  d8888b  d8888b   88bd8b,d88b   d8888b
#   d88  d8P' d8P'd8b_,dP 888 d8P' `P d8P' ?88  88P'`?8P'?8b d8b_,dP
#   ?8b ,88b ,88' 88b     88b 88b     88b  d88 d88  d88  88P 88b
#   `?888P'888P'  `?888P'  88b`?888P' `?8888P'd88' d88'  88b `?888P'

# ~/.local/bin/welcome

# Author       : Chris-1101 @ GitHub
# Description  : Prints some simple ASCII art
# Dependencies : lolcat

# =================
# --- Execution ---
# =================

# Spacer
printf $'\n'

# Welcome Box
printf '%s\n' \
  "   ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗" \
  "   ║                                                                                                                               ║" \
  "   ║                         d8b         d8b                 d8b                                  d8b                              ║" \
  "   ║                         ?88        88P                  ?88                      welcome     ?88                              ║" \
  "   ║                          88b      d88                    88b                                  88b                             ║" \
  "   ║                          888888b  888  d888b8b   d8888b  888  d88' d888b8b    88bd88b d8888b  888888b                         ║" \
  "   ║                          88P \`?8b 888 d8P' ?88  d8P' \`P  888bd8P' d8P' ?88    88P'  \`d8P' \`P  88P \`?8b                        ║" \
  "   ║                         d88,  d88 88b 88b  ,88b 88b     d88888b   88b  ,88b  d88     88b     d88   88P                        ║" \
  "   ║                        d88'\`?88P'  88b\`?88P'\`88b\`?888P'd88' \`?88b,\`?88P'\`88bd88'     \`?888P'd88'   88b                        ║" \
  "   ║                                                                                                                               ║" \
  "   ╚═════════════════════════════════════════════════════════════ linux ═══════════════════════════════════════════════════════════╝" \
  | lolcat

# Spacer
printf $'\n'