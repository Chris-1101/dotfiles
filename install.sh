#!/usr/bin/env bash

#    __                 __          __   __
#   |__| ____   _______/  |______  |  | |  |
#   |  |/    \ /  ___/\   __\__  \ |  | |  |
#   |  |   |  \\___ \  |  |  / __ \|  |_|  |__
#   |__|___|  /____  > |__| (____  /____/____/ - automatically symlink dotfiles
#           \/     \/            \/              requires origin comments (?!:) pointing to desired installation path

#?!:void

# Counter Variable
count=0

# Recursive Install Script
function symlink_origin
{
    local dir=$1
    local origin_regex="(?<=\?\!\:).+"
    local exclude="void"

    if [[ -d $dir ]]; then
        #echo "RECURSION: $dir validated as a directory" # debug purposes
        for object in "$dir"/*; do
            if [[ -d $object ]]; then
                symlink_origin "$object"
            else
                [[ -h "$object" || ! -f "$object" ]] && continue
                #echo "FILE: $object" # debug purposes
                local origin=$([[ -f $object || -x $object ]] && head -10 "$object" | grep -oP $origin_regex | cat)
                # Expand $HOME or skip this file if no origin comment was found
                [[ -n $origin ]] && origin=$(eval echo "$origin") || continue
                #[[ -n $origin && $origin != $exclude ]] && echo "ORIGIN: $origin" && ((count++)) # debug purposes
                [[ -n $origin && $origin != $exclude ]] && ln -sf "$object" "$origin" && ((count++))
                echo -ne \\r$count files successfully symlinked to their origin
            fi
        done
    else
        echo "Invalid directory: $dir"
        exit 1
    fi
}

# Launch the Script
#if [[ -z $1 ]]; then
#    symlink_origin $DOTFILES_DIR
#else
#    symlink_origin "$1"
#fi

declare -A symlinks

symlinks["uno"]="testing"
symlinks["duo"]="still testing"
symlinks["trio"]="uh huh"

for numero in "${!symlinks[@]}"; do
    echo "$numero is ${symlinks[$numero]}"
done | tac
