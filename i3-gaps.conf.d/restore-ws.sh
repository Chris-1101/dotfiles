#!/usr/bin/env bash
#    __________        __      __             __
#   |__\_____  \      /  \    /  \___________|  | __ _________________   _____  ____   ______
#   |  | _(__  < _____\   \/\/   /  _ \_  __ \  |/ //  ___/\____ \__  \ /  ___\/ __ \ /  ___/
#   |  |/       \ _____\        (  (_) )  | \/    < \___ \ |  |_) ) __ \\  \__\  ___/ \___ \
#   |__/______  /       \__/\  / \____/|__|  |__|_ \____  >|   __(____  /\___  >___  >____  >
#             \/             \/                   \/    \/ |__|       \/     \/    \/     \/

# install:set type=user path=$HOME/.config/i3/restore-ws.sh

# Launch Workspace 2
i3-msg "workspace 2; append_layout ~/.config/i3/workspace-2.json"

# Restore Workspace 2
urxvt -title 'Ranger File Manager' -name ranger -e $SHELL -c "ranger && $SHELL" &
urxvt -name urxvt1 -e $SHELL -c "lolcat < <(boxecho < <(~/.dotfiles/scripts/quotegen)) && ~/.dotfiles/scripts/startup.sh && $SHELL" &
urxvt -name urxvt2 -e $SHELL -c "neofetch && dfc -dfsp /dev -q name && echo && $SHELL" &
urxvt -title 'System Monitor' -name htop -e $SHELL -c "htop && $SHELL" &
