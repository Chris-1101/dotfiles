#!/usr/bin/env bash

#                 __  _____
#    __ __  ____ |__|/ ____\___________  _____
#   |  |  \/    \|  \   __\/  _ \_  __ \/     \
#   |  |  /   |  \  ||  | (  <_> )  | \/  Y Y  \
#   |____/|___|  /__||__|  \____/|__|  |__|_|  /
#   unicode    \/    formatting              \/

#?!:$HOME/.dotfiles/scritps/uniform

# Author       : Chris-1101
# GitHub       : https://github.com/Chris-1101
# Description  : Format text with unicode symbols
# Dependencies : bash > 4.0 (associative arrays)

# ╔═════════════════════════════════════════╗
# ╟─────────────╼ Definitions ╾─────────────╢
# ╚═════════════════════════════════════════╝

charpool_basic=(
    'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm'
    'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z'
    'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M'
    'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'
)

charpool_regular=(
    '𝖺' '𝖻' '𝖼' '𝖽' '𝖾' '𝖿' '𝗀' '𝗁' '𝗂' '𝗃' '𝗄' '𝗅' '𝗆'
    '𝗇' '𝗈' '𝗉' '𝗊' '𝗋' '𝗌' '𝗍' '𝗎' '𝗏' '𝗐' '𝗑' '𝗒' '𝗓'
    '𝖠' '𝖡' '𝖢' '𝖣' '𝖤' '𝖥' '𝖦' '𝖧' '𝖨' '𝖩' '𝖪' '𝖫' '𝖬'
    '𝖭' '𝖮' '𝖯' '𝖰' '𝖱' '𝖲' '𝖳' '𝖴' '𝖵' '𝖶' '𝖷' '𝖸' '𝖹'
)

charpool_bold=(
    '𝗮' '𝗯' '𝗰' '𝗱' '𝗲' '𝗳' '𝗴' '𝗵' '𝗶' '𝗷' '𝗸' '𝗹' '𝗺'
    '𝗻' '𝗼' '𝗽' '𝗾' '𝗿' '𝘀' '𝘁' '𝘂' '𝘃' '𝘄' '𝘅' '𝘆' '𝘇'
    '𝗔' '𝗕' '𝗖' '𝗗' '𝗘' '𝗙' '𝗚' '𝗛' '𝗜' '𝗝' '𝗞' '𝗟' '𝗠'
    '𝗡' '𝗢' '𝗣' '𝗤' '𝗥' '𝗦' '𝗧' '𝗨' '𝗩' '𝗪' '𝗫' '𝗬' '𝗭'
)

charpool_italic=(
    '𝘢' '𝘣' '𝘤' '𝘥' '𝘦' '𝘧' '𝘨' '𝘩' '𝘪' '𝘫' '𝘬' '𝘭' '𝘮'
    '𝘯' '𝘰' '𝘱' '𝘲' '𝘳' '𝘴' '𝘵' '𝘶' '𝘷' '𝘸' '𝘹' '𝘺' '𝘻'
    '𝘈' '𝘉' '𝘊' '𝘋' '𝘌' '𝘍' '𝘎' '𝘏' '𝘐' '𝘑' '𝘒' '𝘓' '𝘔'
    '𝘕' '𝘖' '𝘗' '𝘘' '𝘙' '𝘚' '𝘛' '𝘜' '𝘝' '𝘞' '𝘟' '𝘠' '𝘡'
)

charpool_bolditalic=(
    '𝙖' '𝙗' '𝙘' '𝙙' '𝙚' '𝙛' '𝙜' '𝙝' '𝙞' '𝙟' '𝙠' '𝙡' '𝙢'
    '𝙣' '𝙤' '𝙥' '𝙦' '𝙧' '𝙨' '𝙩' '𝙪' '𝙫' '𝙬' '𝙭' '𝙮' '𝙯'
    '𝘼' '𝘽' '𝘾' '𝘿' '𝙀' '𝙁' '𝙂' '𝙃' '𝙄' '𝙅' '𝙆' '𝙇' '𝙈'
    '𝙉' '𝙊' '𝙋' '𝙌' '𝙍' '𝙎' '𝙏' '𝙐' '𝙑' '𝙒' '𝙓' '𝙔' '𝙕'
)

declare -A charpool

# ╔════════════════════════════════════════╗
# ╟─────────────╼ Formatting ╾─────────────╢
# ╚════════════════════════════════════════╝

function format
{
    local str_new
    local str_old="$@"
    local length=${#charpool_basic[@]}

    # Populate hash with requested font
    for (( i = 0; i < $length; i++ )); do
        charpool["${charpool_basic[$i]}"]="$(eval echo '${charpool_'$font'[$i]}')"
    done

    # Substitue each character for its unicode counterpart
    for (( i = 0; i < ${#str_old}; i++ )); do
        char="${str_old:$i:1}"
        [[ $char = " " ]] && str_new+=" " && continue
        str_new+=${charpool[$char]}
    done

    # Return Result
    echo
    echo "  $str_new"
    echo

    # Clean Up
    unset charpool
    unset charpool_bold
    unset charpool_basic
    unset charpool_italic
    unset charpool_regular
    unset charpool_bolditalic
}

# ╔═══════════════════════════════════════╗
# ╟─────────────╼ Help Page ╾─────────────╢
# ╚═══════════════════════════════════════╝

function help
{
    {
        echo "UNICODE FORMATTING"
        echo
        echo "${LESS_TERMCAP_md}NAME${LESS_TERMCAP_me}"
        echo "       uniform.sh - format text with unicode symbols"
        echo
        echo "${LESS_TERMCAP_md}SYNOPSIS${LESS_TERMCAP_me}"
        echo "       uniform.sh ${LESS_TERMCAP_us}STRING${LESS_TERMCAP_ue}"
        echo "       uniform.sh ${LESS_TERMCAP_md}-r --regular${LESS_TERMCAP_me} ${LESS_TERMCAP_us}STRING${LESS_TERMCAP_ue}"
        echo "       uniform.sh ${LESS_TERMCAP_md}-b --bold${LESS_TERMCAP_me} ${LESS_TERMCAP_us}STRING${LESS_TERMCAP_ue}"
        echo "       uniform.sh ${LESS_TERMCAP_md}-i --italic${LESS_TERMCAP_me} ${LESS_TERMCAP_us}STRING${LESS_TERMCAP_ue}"
        echo "       uniform.sh ${LESS_TERMCAP_md}-bi --bold-italic${LESS_TERMCAP_me} ${LESS_TERMCAP_us}STRING${LESS_TERMCAP_ue}"
        echo "       uniform.sh ${LESS_TERMCAP_md}-h --help${LESS_TERMCAP_me} ${LESS_TERMCAP_us}STRING${LESS_TERMCAP_ue}"
        echo "       uniform.sh"
        echo
        echo "${LESS_TERMCAP_md}DESCRIPTION${LESS_TERMCAP_me}"
        echo "       Applies formatting to simple alphabetical strings by converting each character to their formatted"
        echo "       unicode counterpart. Only lower and uppercase basic latin characters are supported (a-z, A-Z)"
        echo
        echo "       Used codepoints belong to the 'Mathematical Alphanumeric Symbols' block (U+1D400 - U+1D7FF)"
        echo "       https://codepoints.net/mathematical_alphanumeric_symbols"
        echo
        echo "       NOTE: Depending on your terminal font, the result may be a set of squares. The output"
        echo "             may be copied to an environment that can display the symbols regardless"
        echo
        echo "       ${LESS_TERMCAP_us}STRING${LESS_TERMCAP_ue}"
        echo "              String to be formatted. Omitting an option defaults to ${LESS_TERMCAP_md}--bold-italic${LESS_TERMCAP_me}"
        echo
        echo "       ${LESS_TERMCAP_md}-r${LESS_TERMCAP_me}, ${LESS_TERMCAP_md}--regular${LESS_TERMCAP_me}"
        echo "              Use regular formatting"
        echo
        echo "       ${LESS_TERMCAP_md}-b${LESS_TERMCAP_me}, ${LESS_TERMCAP_md}--bold${LESS_TERMCAP_me}"
        echo "              Use bold formatting"
        echo
        echo "       ${LESS_TERMCAP_md}-i${LESS_TERMCAP_me}, ${LESS_TERMCAP_md}--italic${LESS_TERMCAP_me}"
        echo "              Use italic formatting"
        echo
        echo "       ${LESS_TERMCAP_md}-bi${LESS_TERMCAP_me}, ${LESS_TERMCAP_md}--bold-italic${LESS_TERMCAP_me}"
        echo "              Use bold & italic formatting"
        echo
        echo "       ${LESS_TERMCAP_md}-h${LESS_TERMCAP_me}, ${LESS_TERMCAP_md}--help${LESS_TERMCAP_me}"
        echo "              Display this help page"
        echo
        echo "${LESS_TERMCAP_md}AUTHOR${LESS_TERMCAP_me}"
        echo "       Written by Chris MB"
        echo "       Chris-1101 on GitHub: <https://github.com/Chris-1101>"
        echo
        echo "${LESS_TERMCAP_md}COPYRIGHT${LESS_TERMCAP_me}"
        echo "       Copyright (c) 2018 Chris-1101"
        echo "       MIT License: <https://opensource.org/licenses/MIT>"

    } | less
}

# ╔═════════════════════════════════════╗
# ╟─────────────╼ Options ╾─────────────╢
# ╚═════════════════════════════════════╝

case $1 in
    "")
        ;&

    -h|--help)
        help
        ;;

    -r|--regular)
        font="regular"
        format "${@:2}"
        ;;

    -b|--bold)
        font="bold"
        format "${@:2}"
        ;;

    -i|--italic)
        font="italic"
        format "${@:2}"
        ;;

    -bi|--bold-italic)
        font="bolditalic"
        format "${@:2}"
        ;;

    *)
        font="bolditalic"
        format "$@"
        ;;
esac
