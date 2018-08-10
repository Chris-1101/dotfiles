#!/usr/bin/env bash
#                        __
#     ________ __  _____/  |_  ____  ______ ____   ____   ____
#    / ____/  |  \/  _ \   __\/ __ \/  ___// ___\_/ __ \ /    \
#   ( (_|  |  |  (  (_) )  | \  ___/\___ \/ /_/  >  ___/|   |  \
#    \__   |____/ \____/|__|  \___  >___  >___  / \___  >___|  /
#       |__|                      \/    \/(____/      \/     \/

# install:set type=root path=/usr/bin/quotesgen

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Randomly print quotes from a flat-file database
# Dependencies : bash >= 4.0 (mapfile)

# Path to the quotes file, each line is assumed to be a separate quote
# TODO move location to ~/.cache
quotes_db=~/.dotfiles/scripts/QUOTES

# Process the file, ignoring empty lines and comments (#)
mapfile -t quotes < <(grep -v -E '^$|^#.*$' "$quotes_db")

# TODO randomise quotes
# TODO handle number of quotes to print via -n option
echo "${#quotes[@]} total quotes"
echo "${quotes[0]}"
echo "${quotes[1]}"
