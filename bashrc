
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
PS1='$(printf "%*s\r%s" $(( COLUMNS )) "$(git branch 2>/dev/null | grep '^*' | sed s/..//) [$(date +%H:%M)]" "[\W] \033[0;32m»\033[0m ")'

#if git rev-parse --git-dir > /dev/null 2>&1; then
#    PS1='$(printf "%*s\r%s" $(( COLUMNS-1 )) "[$(git branch 2>/dev/null | grep '^*' | sed s/..//)] [$(date +%H:%M)]" "[\W] » ")'
#else
#    PS1='$(printf "%*s\r%s" $(( COLUMNS-1 )) "[$(date +%H:%M)]" "[\W] » ")'
#fi

# Autorun
neofetch
