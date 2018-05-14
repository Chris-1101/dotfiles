#!/usr/bin/env bash
#                                           ___       __
#   _____   __ _________   __ ________   __| _/____ _/  |_  ____   ______
#   \__  \ |  |  \_  __ \ |  |  \____ \ / __ |\__  \\   __\/ __ \ /  ___/
#    / __ \|  |  /|  | \/ |  |  /  |_> > /_/ | / __ \|  | \  ___/ \___ \
#   (____  /____/ |__|    |____/|   __/\____ |(____  /__|  \___  >____  >
#        \/                     |__|        \/     \/          \/     \/

#?!:$HOME/.config/polybar/updates-aur.sh

# Updates: Arch User Repository (aurutils)
updates_aur=$(aurcheck -d aur | wc -l) || "0"
echo "$updates_aur"
