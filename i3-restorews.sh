#!/usr/bin/env bash

# Launch Workspace 2
i3-msg "workspace 2; append_layout ~/.config/i3/workspace-2.json"

# Restore Workspace 2
urxvt -title 'Terminal - Ranger' -name ranger -e ranger &
urxvt -name urxvt1 &
urxvt -name urxvt2 &
urxvt -title 'Terminal - htop' -name htop -e htop &

# Done
echo "i3 workspaces restored."
