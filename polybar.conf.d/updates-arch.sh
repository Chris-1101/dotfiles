#!/usr/bin/env bash
#                         __                        ___       __
#   _____ _______  _____ |  |__    __ ________   __| _/____ _/  |_  ____   ______
#   \__  \\_  __ \/  ___\|  |  \  |  |  \____ \ / __ |\__  \\   __\/ __ \ /  ___/
#    / __ \|  | \/\  \___|   Y  \ |  |  /  |_) ) /_/ | / __ \|  | \  ___/ \___ \
#   (____  /__|    \___  >___|  / |____/|   __/\____ |(____  /__|  \___  >____  >
#        \/            \/     \/        |__|        \/     \/          \/     \/

# install:set type=user path=$HOME/.config/polybar/updates-arch.sh

# Updates: Arch Official Repositories
updates_aor=$(/usr/bin/checkupdates 2> /dev/null | wc -l) || "0"
echo "$updates_aor"
