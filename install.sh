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

# TODO implement check mode? => checks for errors, lists both user and root, and exists

# ==================================
# ------- 𝙁𝙤𝙧𝙢𝙖𝙩 𝘿𝙚𝙛𝙞𝙣𝙞𝙩𝙞𝙤𝙣𝙨 -------
# ==================================
f_bld=$(tput bold)
f_blk=$(tput setaf 0)
f_red=$(tput setaf 1)
f_grn=$(tput setaf 2)
f_ylw=$(tput setaf 3)
f_blu=$(tput setaf 4)
f_mag=$(tput setaf 5)
f_cyn=$(tput setaf 6)
f_wht=$(tput setaf 7)
f_rst=$(tput sgr0)

# ====================================
# ------- 𝙁𝙪𝙣𝙘𝙩𝙞𝙤𝙣　𝘿𝙚𝙛𝙞𝙣𝙞𝙩𝙞𝙤𝙣𝙨 -------
# ====================================
# Recursively Find Dotfile/Origin Pairs
function find_dotfiles
{
  local dir=$1
  local is_directory="origin.path"

  # Guard against invalid parameters
  if [[ -d $dir ]]; then

    [[ -n $verbose ]] && printf "Scanning directory $dir\n"

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
        [[ -z $scan_lines ]] && scan_lines=10
        local origin=$([[ -f $object || -x $object ]] && head -$scan_lines "$object" | grep -oP "$origin_regex")

        # Process file paths and origins
        if [[ -n $origin ]]; then

          # Expand paths and variables
          local actual=$(readlink -f "$object")
          origin=$(eval printf "${origin//$'\r'}\n")

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
    printf "Invalid directory: $dir\n"
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
    [[ -n $verbose ]] && printf "\n"
    printf "The following symbolic links will be created:\n"

    # Evaluate and print dotfile/origin pairs
    for f_path in "${!symlinks[@]}"; do
      if [[ $(grep ^dir_err <<< $f_path) ]]; then
        printf " • [${f_red}✘${f_rst}] ${f_ylw}${symlinks[$f_path]}${f_rst} — ${f_red}directory doesn't exist${f_rst}\n"
      elif [[ $(grep ^write_err <<< $f_path) ]]; then
        printf " • [${f_red}✘${f_rst}] ${f_ylw}${symlinks[$f_path]}${f_rst} — ${f_red}location requires root${f_rst}\n"
      else
        printf " • [${f_grn}✔${f_rst}] ${f_cyn}${symlinks[$f_path]}${f_rst} ─➤ ${f_path}\n"
      fi
    done | sort

    printf "(total ${f_ylw}${find_count}${f_rst}) (errors ${f_ylw}${error_count}${f_rst})\n"

    # Check for errors
    if [[ $error_count -eq 0 ]]; then
      # Prompt for confirmation
      if [[ -z $ln_interactive ]]; then
        read -p "${f_blu}::${f_rst} ${f_bld}Existing files/symlinks will be overwritten without confirmation, continue? [y/N]${f_rst} "
      else
        read -p "${f_blu}::${f_rst} ${f_bld}You'll be prompted to overwrite existing files/symlinks, continue? [y/N]${f_rst} "
      fi

      # Process and link paths
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        local ln_opts="-s"
        [[ -z $ln_interactive ]] && ln_opts+="f" || ln_opts+="i"
        [[ -n $verbose ]] && ln_opts+="v"

        local link_count=0

        for f_path in "${!symlinks[@]}"; do
          ln $ln_opts "$f_path" "${symlinks[$f_path]}"
          [[ $? -eq 0 ]] && ((link_count++))
        done

        printf "$link_count dotfiles successfully processed\n"
      fi
    else
      printf "Errors found: resolve them and run the script again\n"
      printf "Run install.sh -h for troubleshooting tips\n"
    fi
  else
    printf "No files to symlink...\n"
  fi
}

# =======================================
# ------- 𝙋𝙖𝙧𝙖𝙢𝙚𝙩𝙚𝙧 𝙈𝙖𝙣𝙖𝙜𝙚𝙢𝙚𝙣𝙩 -------
# =======================================
while getopts ":hivs:" opt; do
  case $opt in
    h)
      man -l "$(dirname $0)"/install.sh.1
      exit 0
      ;;
    s)
      if [[ $OPTARG =~ [0-9]+ ]]; then
        scan_lines=$OPTARG
      else
        printf "Invalid argument passed to -l: $OPTARG. Must be an integral number.\n"
        exit 1
      fi
      ;;
    i)
      ln_interactive=true
      ;;
    v)
      verbose=true
      ;;
    :)
      printf "Option -$OPTARG requires an argument\n"
      exit 1
      ;;
    *)
      printf "Invalid option: -$OPTARG, run install.sh -h for usage instructions\n"
      exit 1
      ;;
  esac
done

# Restore Positional Parameters
shift "$((OPTIND-1))"

# Execute Script
if [[ $# -eq 0 ]]; then
  symlink_dotfiles .
elif [[ -n $1 ]]; then
  symlink_dotfiles $1
fi
