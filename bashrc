
#   ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
#   ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
#   ██████╔╝███████║███████╗███████║██████╔╝██║
#   ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║
#   ██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
#   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Function Aliases
alias grep='grep --colour=auto'
alias ls='ls --color=auto'
alias tr='tree -a'
alias symlink='ln -s'
alias aurinfo='packer -Si'
alias aurlist='pacman -Sl aur'

# Make Vim follow symbolic links
function vim() {
    args=()
    for i in $@; do
        if [[ -h $i ]]; then
            args+=`readlink $i`
        else
            args+=$i
        fi
    done

    /usr/bin/vim -p "${args[@]}"
}

# Shell Prompt
PS1='$(printf "%*s\r%s" $(( COLUMNS-1 )) "$(git branch 2>/dev/null | grep '^*' | sed s/..//) [$(date +%H:%M)]" "[\W] \033[0;32m»\033[0m ")'

# Powerline
#powerline-daemon -q
#POWERLINE_BASH_CONTINUATION=1
#POWERLINE_BASH_SELECT=1
#. /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh

# Autorun
neofetch
