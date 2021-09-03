#!/usr/bin/env bash
#                                  d8b
#                       i3-gaps    ?88
#                                   88b
#   ?88   d8P  d8P d8888b   88bd88b 888  d88' .d888b,?88,.d88b,  d888b8b   d8888b d8888b .d888b,
#   d88  d8P' d8P'd8P' ?88  88P'  ` 888bd8P'  ?8b,   `?88'  ?88 d8P' ?88  d8P' `Pd8b_,dP ?8b,
#   ?8b ,88b ,88' 88b  d88 d88     d88888b      `?8b   88b  d8P 88b  ,88b 88b    88b       `?8b
#   `?888P'888P'  `?8888P'd88'    d88' `?88b,`?888P'   888888P' `?88P'`88b`?888P'`?888P'`?888P'
#                                                      88P'
#                                                     d88    Workspace Restoration Script
#   ~/.config/i3/workspaces.sh                       ?8P

# Author       : Chris-1101 @ GitHub
# Description  : Restores i3 workspace configuration at boot
# Dependencies : alacritty, htop, i3-msg, ranger

# Restore Workspace 2 Layout
i3-msg "workspace 2; append_layout ~/.config/i3/workspace-2.json" && sleep 1

# Restore Workspace 2 Containers
alacritty -t 'Ranger File Manager' -e $SHELL -ic "ranger ~/Pictures/Wallpapers; $SHELL" &!
alacritty -t 'Terminal 1'          -e $SHELL -ic "welcome; $SHELL" &!
alacritty -t 'Terminal 2'          -e $SHELL -ic "boxecho 'initialising...' && represent; $SHELL" &!
alacritty -t 'System Monitor'      -e $SHELL -ic "htop; $SHELL" &!
