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
# Dependencies : bash >= 4.0 (associative arrays)

# Recursively Find Dotfile/Origin Pairs
function find_dotfiles
{
  local dir=$1
  local is_directory="origin.path"

  # Guard against invalid parameters
  if [[ -d $dir ]]; then

    [[ -n $verbose ]] && echo "Scanning directory $dir"

    for object in "$dir"/*; do

      if [[ -d $object ]]; then
        # Avoid some needless work
        [[ $(basename $object) = ".git" ]] && continue

        # Chase sub-directories
        find_dotfiles "$object"
      else
        # Skip if symlink or not a regular file
        [[ -h "$object" || ! -f "$object" ]] && continue

        # Check User Permissions
        if [[ $EUID -eq 0 ]]; then
          local origin_regex="(?<=install:set type=root path=).+"
        else
          local origin_regex="(?<=install:set type=user path=).+"
        fi

        # Find and store origin
        local origin=$([[ -f $object || -x $object ]] && head -10 "$object" | grep -oP "$origin_regex")

        # Process file paths and origins
        if [[ -n $origin ]]; then

          # Expand paths and variables
          local actual=$(readlink -f "$object")
          origin=$(eval echo "${origin//$'\r'}")

          # For directories, keep only directory name
          if [[ "$object" = *$is_directory ]]; then
            actual=$(dirname "$actual")/
          fi

          # Check that directories exist and are writable
          if [[ ! -d $(dirname $origin) ]]; then
            ((error_count++))
            actual="dir_err$error_count"
          elif [[ ! -w $(dirname $origin) ]]; then
            ((error_count++))
            actual="write_err$error_count"
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
  error_count=0
  find_count=0

  # Remember user's globbing settings
  local dotglob=$(shopt -p dotglob)
  shopt -s dotglob

  # Obtain file paths
  find_dotfiles $1

  # Restore user's globbing settings
  eval $dotglob

  # Check for matches
  if [[ $find_count -ne 0 ]]; then
    [[ -n $verbose ]] && echo
    echo "The following symbolic links will be created:"

    # Evaluate and print dotfile/origin pairs
    for f_path in "${!symlinks[@]}"; do
      if [[ $(grep ^dir_err <<< $f_path) ]]; then
        echo -e " • [\e[31m✘\e[0m] \e[33m${symlinks[$f_path]}\e[0m — \e[31mdirectory doesn't exist\e[0m"
      elif [[ $(grep ^write_err <<< $f_path) ]]; then
        echo -e " • [\e[31m✘\e[0m] \e[33m${symlinks[$f_path]}\e[0m — \e[31mlocation requires root\e[0m"
      else
        echo -e " • [\e[32m✔\e[0m] \e[36m${symlinks[$f_path]}\e[0m ─➤ $f_path"
      fi
    done | sort

    echo "(total $find_count) (errors $error_count)"

    # Check for errors
    if [[ $error_count -eq 0 ]]; then
      # Prompt for confirmation
      if [[ -z $ln_interactive ]]; then
        read -p ":: Existing files/symlinks will be overwritten without confirmation, continue? [y/N] "
      else
        read -p ":: You'll be prompted to overwrite existing files/symlinks, continue? [y/N] "
      fi

      # Process and link paths
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        local ln_opts="-s"
        [[ -z $ln_interactive ]] && ln_opts+="f" || ln_opts+="i"
        [[ -n $verbose ]] && ln_opts+="v"

        local link_count=0

        for f_path in "${!symlinks[@]}"; do
          ln $ln_opts "$f_path" "${symlinks[$f_path]}" && ((link_count++))
        done

        echo "$link_count dotfiles successfully symlinked to their originial location"
      fi
    else
      echo "Errors found: resolve them and run the script again"
      echo "Run install.sh -h for troubleshooting tips"
    fi
  else
    echo "No files to symlink..."
  fi
}

# Estimate Directory When Unspecified
function estimate_dir
{
  local install_dir

  if [[ $EUID -eq 0 ]]; then
    if [[ -z $DOTFILES_DIR ]]; then
      install_dir="$(eval echo ~$SUDO_USER)/.dotfiles"
    else
      install_dir="$(sudo -u $SUDO_USER eval echo $DOTFILES_DIR)"
    fi
  else
    if [[ -z $DOTFILES_DIR ]]; then
      install_dir="$HOME/.dotfiles"
    else
      install_dir="$DOTFILES_DIR"
    fi
  fi

  symlink_dotfiles $install_dir
}

# Clean Up (Needed?)
function run_gc
{
  unset verbose
  unset symlinks
  unset find_count
  unset error_count
  unset ln_interactive
  unset estimate_dir
  unset find_dotfiles
  unset symlink_dotfiles
}

# Handle Options
while getopts ":hiv" opt; do
  case $opt in
    h)
      man -l "$(dirname $0)"/install.sh.1
      exit 0
      ;;
    i)
      ln_interactive=true
      ;;
    v)
      verbose=true
      ;;
    *)
      echo "Invalid option: -$OPTARG, run install.sh -h for usage instructions"
      exit 1
      ;;
  esac
done

# Restore Positional Parameters
shift "$((OPTIND-1))"

# Execute Script
if [[ $# -eq 0 ]]; then
  estimate_dir
elif [[ -n $1 ]]; then
  symlink_dotfiles $1
fi

run_gc
unset run_gc
