#!/usr/bin/env bash

#                         __                        ___       __
#   _____ _______   ____ |  |__    __ ________   __| _/____ _/  |_  ____   ______
#   \__  \\_  __ \_/ ___\|  |  \  |  |  \____ \ / __ |\__  \\   __\/ __ \ /  ___/
#    / __ \|  | \/\  \___|   Y  \ |  |  /  |_> > /_/ | / __ \|  | \  ___/ \___ \
#   (____  /__|    \___  >___|  / |____/|   __/\____ |(____  /__|  \___  >____  >
#        \/            \/     \/        |__|        \/     \/          \/     \/

#?!:$HOME/.config/polybar/updates-arch.sh

# List Pending Updates
updates=$(checkupdates | wc -l)

# Print Number of Updates
if [ "$updates" -gt 0 ]; then
    echo "$updates"
else
    echo "0"
fi
