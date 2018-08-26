#!/usr/bin/env bash
#   __________                            __
#   \______   \ _______  ___ ____  _____ |  |__   ____
#    |    |  _//  _ \  \/  // __ \/  ___\|  |  \ /  _ \
#    |    |   (  (_) >    <\  ___/\  \___|   Y  (  (_) )
#    |______  /\____/__/\_ \\___  >\___  >___|  /\____/
#           \/            \/    \/     \/     \/

# Author       : Chris MB
# GitHub       : https://github.com/Chris-1101
# Description  : Frame and centre input based on terminal width
# Dependencies : none

# ==================================================
# ------- 𝙍𝙚𝙖𝙙 𝙋𝙞𝙥𝙚𝙙 𝙖𝙣𝙙 𝙍𝙚𝙙𝙞𝙧𝙚𝙘𝙩𝙚𝙙 𝙊𝙪𝙩𝙥𝙪𝙩 -------
# ==================================================
declare lf=$'\n'
declare input

# Normalise Input
if [[ -p /dev/stdin ]]; then
  while IFS= read line; do
    input+="${line}$lf"
  done
  input=${input%?}
else
  input="$@"
fi

# Simulate echo's behaviour
[[ -z $input ]] && printf "$lf" && exit 0

# ====================================
# ------- 𝙁𝙪𝙣𝙘𝙩𝙞𝙤𝙣　𝘿𝙚𝙛𝙞𝙣𝙞𝙩𝙞𝙤𝙣𝙨 -------
# ====================================
# Various widths to keep track of
declare -i width_term=$(tput cols)
declare -i width_frame=$((width_term - 8))
declare -i width_content=$((width_frame - 6))

# Frame Input
function build_frame
{
  case "$1" in
    top)
      local char_beg="╔"
      local char_mid="═"
      local char_end="╗"
      ;;
    spacer)
      local char_beg="║"
      local char_mid=" "
      local char_end="║"
      ;;
    bottom)
      local char_beg="╚"
      local char_mid="═"
      local char_end="╝"
      ;;
    *)
      return
      ;;
  esac

  local frame_builder

  for (( i = 0; i < $width_frame; i++ )); do
    frame_builder+="$char_mid"
  done

  printf "   ${char_beg}${frame_builder}${char_end}\n"
}

# Centre Input
function build_content
{
  local -r input="$1"
  local -i count
  local string_builder

  # Reset Line
  function sb_reset
  {
    count=0
    string_builder=""
  }

  # Append to Line
  function sb_append
  {
    (( count += ${#1} ))
    string_builder+="$1"
  }

  # Prepend to Line
  function sb_prepend
  {
    (( count += ${#1} ))
    string_builder="${1}$string_builder"
  }

  # Print Line
  function sb_print
  {
    local -i width_string=${#string_builder}
    local -i width_padding=$(( (width_content - width_string) / 2 ))
    local -i parity_string=$(( width_string % 2 ))
    local -i parity_term=$(( width_term % 2 ))
    local padding=""

    if [[ $width_string -lt $width_content ]]; then

      # Keep parity of string inline with that of terminal
      [[ $parity_term -ne $parity_string ]] && sb_prepend " "

      # Override padding for blank lines
      [[ $count -eq 0 ]] && width_padding=$(( width_content / 2 ))

      # Build padding to centre input
      for (( i = 0; i < $width_padding; i++ )); do
        padding+=" "
      done

    fi

    # Formatting all done, print result
    printf "   ║   ${padding}${string_builder}${padding}   ║\n"
  }

  # Break down input line-by-line
  local -a sentences && readarray -d $'\n' sentences <<< "$input"

  # NOTE `for foo in ${bar[@]}` nukes blank lines ¯\_(ツ)_/¯
  for i in ${!sentences[@]}; do

    # Break down sentence into words
    local sentence="${sentences[i]}"
    local -a words=($sentence)

    # Initialise/reset string builder
    sb_reset

    # Process word-by-word
    for word in ${words[@]}; do

      local -i width_sofar=${#string_builder}+${#word}

      # Concatenate based on current line length
      if [[ $width_sofar -gt $width_content ]]; then
        sb_print
        sb_reset
        sb_append "$word"
      elif [[ $width_sofar -eq $width_content ]]; then
        sb_append "$word"
        sb_print
        sb_reset
      else
        sb_append "$word"
      fi

      # At the end of the word, add a space
      # Unless at start of a new line (count = 0)
      [[ $count -ne 0 ]] && sb_append " "

    done

    # At the end of the line, print line
    sb_print

  done
}

# ==========================
# ------- 𝙍𝙪𝙣 𝙎𝙘𝙧𝙞𝙥𝙩 -------
# ==========================
printf "$lf"
build_frame top
build_frame spacer
build_content "$input"
build_frame spacer
build_frame bottom
printf "$lf"
