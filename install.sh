#!/usr/bin/env bash

#    __                 __          __   __
#   |__| ____   _______/  |______  |  | |  |
#   |  |/    \ /  ___/\   __\__  \ |  | |  |
#   |  |   |  \\___ \  |  |  / __ \|  |_|  |__
#   |__|___|  /____  > |__| (____  /____/____/
#           \/     \/            \/

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Automatically symlink dotfiles
# Dependencies : bash > 4.0 (associative arrays)

# Guard Against Root
if [[ $EUID -eq 0 ]]; then
    echo "This script isn't meant to be run as root!"
    exit 1
fi

# Recursively Find Dotfile/Origin Pairs
function find_dotfiles
{
    # For the sake of readability
    local dir=$1
    local origin_regex="(?<=\?\!\:).+"
    local is_directory="origin.path"
    local exclude="exclude"

    # Guard against invalid parameters
    if [[ -d $dir ]]; then

        for object in "$dir"/*; do

            if [[ -d $object ]]; then
                # Chase sub-directories
                find_dotfiles "$object"
            else
                # Skip if symlink or not a regular file
                [[ -h "$object" || ! -f "$object" ]] && continue

                # Find and store origin
                local origin=$([[ -f $object || -x $object ]] && head -10 "$object" | grep -oP $origin_regex)

                # Process file paths and origins
                if [[ -n $origin && $origin != $exclude ]]; then

                    # Expand paths and variables
                    origin=$(eval echo "$origin")
                    actual=$(readlink -f "$object")

                    # For directories, keep only directory name
                    if [[ "$object" = *$is_directory ]]; then
                        actual=$(dirname "$actual")/
                    fi

                    # Store results in hash
                    symlinks["$actual"]="$origin"
                    ((find_count++))

                else
                    continue
                fi
            fi

        done

    else
        echo "Invalid directory: $dir"
        exit 1
    fi
}

# Create Symbolic Links
function symlink_dotfiles
{
    # Associative array
    declare -A symlinks
    find_count=0

    # Obtain file paths
    find_dotfiles $1

    # Check for matches
    if [[ $find_count -ne 0 ]]; then
        echo "The following symbolic links will be created:"

        # Print dotfile/origin pairs in reverse order
        for f_path in "${!symlinks[@]}"; do
            echo "$(printf '\e[36m')${symlinks[$f_path]}$(printf '\e[0m') ─➤ $f_path"
        done | sort

        # Prompt for confirmation
        echo "(total $find_count)"
        read -p ":: Existing files/symlinks will be overwritten without confirmation, continue? [Y/n] "

        # Process and link paths
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            local link_count=0
            for f_path in "${!symlinks[@]}"; do
                ln -sf "$f_path" "${symlinks[$f_path]}" && ((link_count++))
                printf "\\r$link_count dotfiles successfully symlinked to their originial location"
            done
        fi
    else
        echo "No files to symlink..."
    fi

    # Not sure if this is needed
    unset symlinks
}

# Simulated Man Page
function help
{
    {
        echo "DOTFILES INSTALLATION SCRIPT"
        echo
        echo "${LESS_TERMCAP_md}NAME${LESS_TERMCAP_me}"
        echo "       install.sh - automatically symlink dotfiles to their original location"
        echo
        echo "${LESS_TERMCAP_md}SYNOPSIS${LESS_TERMCAP_me}"
        echo "       install.sh ${LESS_TERMCAP_us}DIRECTORY${LESS_TERMCAP_ue}"
        echo "       install.sh ${LESS_TERMCAP_md}-h --help${LESS_TERMCAP_me}"
        echo "       install.sh"
        echo
        echo "${LESS_TERMCAP_md}DESCRIPTION${LESS_TERMCAP_me}"
        echo "       This script is intended for use in repositories with custom directory structures. If you want"
        echo "       complete freedom in organising, moving and renaming your dotfiles at will, this script will still"
        echo "       be able to correctly link files & directories back to their originally intended location. Given,"
        echo "       of course, that you satisfy requirements listed below (some assembly required!)"
        echo
        echo "       ${LESS_TERMCAP_us}DIRECTORY${LESS_TERMCAP_ue}"
        echo "              Runs through the specified directory & sub-directories, searching each file for an origin"
        echo "              Once the search is complete, results are printed in 'origin ─➤ dotfile' pairs for review"
        echo "              User is then prompted for confirmation to create/update the symbolic links"
        echo
        echo "       NOTE: This script forcibly overwrites existing files and symbolic links, so review carefully!"
        echo
        echo -e "       An omitted DIRECTORY defaults to \$DOTFILES_DIR (if set) or ~/.dotfiles"
        echo
        echo "       ${LESS_TERMCAP_md}-h${LESS_TERMCAP_me}, ${LESS_TERMCAP_md}--help${LESS_TERMCAP_me}"
        echo "              Display this help page"
        echo
        echo "${LESS_TERMCAP_md}REQUIREMENTS${LESS_TERMCAP_me}"
        echo "       Dotfiles must include a comment in the first ${LESS_TERMCAP_us}10${LESS_TERMCAP_ue} lines pointing to their origin path"
        echo "       If a directory is to be linked, it must contain an ${LESS_TERMCAP_us}origin.path${LESS_TERMCAP_ue} file with the relevant path"
        echo
        echo "       NOTE: Not all directories require such a file. Only those that are to be themselves linked"
        echo "       WARNING: Don't mix file paths (comments) & directory paths (origin.path) in the same directory"
        echo
        echo -e "       This script cannot be run as root due to the expansion of user-specific env variables like \$HOME"
        echo "       As such, files that belong in locations that require root access are not supported by this script"
        echo "       Any such files should use the exclude comment or ommit it completely"
        echo
        echo "${LESS_TERMCAP_md}PATH COMMENTS FORMAT${LESS_TERMCAP_me}"
        echo -e "       Environment variables like \$HOME may be used"
        echo "       NOTE: This format applies to both dotfiles and origin.path files"
        echo
        echo "       ?!:/path/to/original/location/original.name    - link"
        echo "       ?!:exclude                                     - skip"
        echo "       <no comment>                                   - skip"
        echo
        echo "${LESS_TERMCAP_md}AUTHOR${LESS_TERMCAP_me}"
        echo "       Written by Chris MB"
        echo "       Chris-1101 on GitHub: <https://github.com/Chris-1101>"
        echo
        echo "${LESS_TERMCAP_md}COPYRIGHT${LESS_TERMCAP_me}"
        echo "       Copyright (c) 2018 Chris-1101"
        echo "       MIT License: <https://opensource.org/licenses/MIT>"
        echo
        echo "${LESS_TERMCAP_md}SEE ALSO${LESS_TERMCAP_me}"
        echo "       https://github.com/Chris-1101/dotfiles"
    } | less
}

# Handle CLI Parameters
case $1 in
    "")
        if [[ -z $DOTFILES_DIR ]]; then
            symlink_dotfiles "$HOME/.dotfiles"
        else
            symlink_dotfiles "$DOTFILES_DIR"
        fi
        ;;
    -h|--help)
        help
        ;;
    *)
        symlink_dotfiles "$1"
        ;;
esac
