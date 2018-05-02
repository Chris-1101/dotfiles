#!/usr/bin/env bash

#    __________                                __
#   |__\_____  \          __  _  _____________|  | __  _________________    ____  ____   ______
#   |  | _(__  <   ______ \ \/ \/ /  _ \_  __ \  |/ / /  ___/\____ \__  \ _/ ___\/ __ \ /  ___/
#   |  |/       \ /_____/  \     (  <_> )  | \/    <  \___ \ |  |_> > __ \\  \__\  ___/ \___ \
#   |__/______  /           \/\_/ \____/|__|  |__|_ \/____  >|   __(____  /\___  >___  >____  >
#             \/                                   \/     \/ |__|       \/     \/    \/     \/

#?!:$HOME/.config/i3/restore-ws.sh

# Launch Workspace 2
i3-msg "workspace 2; append_layout ~/.config/i3/workspace-2.json"

# Restore Workspace 2
urxvt -title 'Terminal - Ranger' -name ranger -e ranger &
urxvt -name urxvt1 &
urxvt -name urxvt2 &
urxvt -title 'Terminal - htop' -name htop -e htop &

# Done
echo "i3 workspaces restored."
