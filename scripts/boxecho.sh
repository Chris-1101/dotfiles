#!/usr/bin/env bash
#   __________                            __
#   \______   \ _______  ___ ____  _____ |  |__   ____
#    |    |  _//  _ \  \/  // __ \/  ___\|  |  \ /  _ \
#    |    |   (  (_) >    <\  ___/\  \___|   Y  (  (_) )
#    |______  /\____/__/\_ \\___  >\___  >___|  /\____/
#           \/            \/    \/     \/     \/

# ====================================================
# ------- 𝙃𝙖𝙣𝙙𝙡𝙚 𝙋𝙞𝙥𝙚𝙙 𝙖𝙣𝙙 𝙍𝙚𝙙𝙞𝙧𝙚𝙘𝙩𝙚𝙙 𝙊𝙪𝙩𝙥𝙪𝙩 -------
# ====================================================
declare lf=$'\n'
declare stdin

# Normalise Input
if [[ -p /dev/stdin ]]; then
  while IFS= read line; do
    stdin+="${line}$lf"
  done
else
  stdin="$@"
fi

# Simulate echo's behaviour
[[ -z $stdin ]] && echo && exit 0

# ====================================
# ------- 𝙁𝙪𝙣𝙘𝙩𝙞𝙤𝙣　𝘿𝙚𝙛𝙞𝙣𝙞𝙩𝙞𝙤𝙣𝙨 -------
# ====================================
declare width_term=$(tput cols)
declare width_box=$((width_term - 8))
declare width_content=$((width_box - 6))

function build_line
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
      local char_beg="║"
      local char_mid="$1"
      local char_end="║"
      ;;
  esac

  local line_builder="   $char_beg"

  for (( i = 0; i < $width_box; i++ )); do
    line_builder+="$char_mid"
  done

  echo "${line_builder}$char_end"
}

function process_input
{
  local str_input=$(echo -e "$1")
  local str_section
  local str_temp
  local c
  local ws_padding

  while (( ${#str_input} > 0 )); do
    str_section="${str_input:0:$width_content}"
    str_temp="   ║   "
    c=0
    ws_padding=0

    while IFS='' read -d '' -n 1 char; do
      (( c++ ))

      if [[ $char = $'\n' ]]; then
        str_temp+=" "
        break
      else
        str_temp+="$char"
      fi
    done < <(echo -ne "$str_section")

    ws_padding=$(( width_content - $c ))

    if [[ $c -lt $width_content ]]; then
      for (( i = 0; i < $ws_padding; i++ )); do
        str_temp+=" "
      done
    fi

    echo "$str_temp   ║"

    str_input="${str_input:$c}"
  done
}

# ============================
# ------- 𝘽𝙪𝙞𝙡𝙙 𝙊𝙪𝙩𝙥𝙪𝙩 -------
# ============================
# echo
#
# build_line top
# build_line spacer
# process_input "$stdin"
# build_line spacer
# build_line bottom
#
# echo

# TODO
# break input into words array
# str += |···
# foreach word in array
#   count += word_length
#   if word = lf
#     str += word + space(content_width - count) + '···|'
#     print str
#     reset count
#   elseif count > content_width - 3 (min)
#     str += word(substring to maxlength-1) + '-' + '···|'
#     print str
#     str = '|···' + rest_of_word
#     reset count
#   else
#     str += word + ' '

starr=".... ..... .......... .......$lf ...."

readarray -d ' ' words <<< "$starr "
unset 'words[-1]'
declare -p words
for i in ${!words[@]}; do
  if [[ ${words[i]} = *$'\n'* ]]; then
    echo "-${words[i]%% }-"
    echo "BOOM, LINE FEED!"
  else
    echo -e "-${words[i]%% }-"
  fi
done
# for word in ${words[@]}; do
#   echo $'${word}'
# done
# declare -p words
