#!/usr/bin/env zsh
#             __                 __
#     _______/  |______ ________/  |_ __ ________
#    /  ___/\   __\__  \\_  __ \   __\  |  \____ \
#    \___ \  |  |  / __ \|  | \/|  | |  |  /  |_) )
#   /____  > |__| (____  /__|   |__| |____/|   __/
#        \/            \/                  |__|

# Author       : Chris MacBain
# GitHub       : https://github.com/Chris-1101
# Description  : consolidate startup scripts/tasks
# Dependencies : z-shell, functions, keychain, powerctl

# Runs in a non-interactive shell, source zshrc
source ~/.zshrc

# Pause script until user is ready to interract
read -s -k "?Startup script initialised, press any key to continue... "
printf $'\n\n'

# Load SSH Agent & Keys
printa "Loading ssh-agent and relevant keys"
eval $(keychain --eval --quiet github) && \
sleep 1 && \
printn "SSH keys successfully added to this session" || \
printe "SSH keys failed to load"
printf $'\n'

# Load Custom udev Rules
printa "Triggering custom udev rules"
sudo udevadm control --reload-rules && sudo udevadm trigger && \
sleep 1 && \
printn "Custom rules successfully loaded" || \
printe "Failed to load custom rules"
printf $'\n'

# Enable & Start PowerCTL Timers
printa "Enabling unit files and timers for powerctl"
systemctl enable lowbat.timer && \
systemctl start lowbat.timer && \
sleep 1 && \
printn "powerctl timers successfully started, run ${f_grn}systemctl list-timers --all${f_rst} for more info" || \
printe "Failed to load powerctl timers"
printf $'\n'
