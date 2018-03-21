#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Function Aliases
alias ls='ls --color=auto'
alias tr='tree -a'
alias symlink='ln -s'

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

#Shell Prompt
PS1='$(printf "%*s\r%s" $(( COLUMNS-1 )) "$(git branch 2>/dev/null | grep '^*' | sed s/..//) [$(date +%H:%M)]" "[\W] » ")'

#if git rev-parse --git-dir > /dev/null 2>&1; then
#    PS1='$(printf "%*s\r%s" $(( COLUMNS-1 )) "[$(git branch 2>/dev/null | grep '^*' | sed s/..//)] [$(date +%H:%M)]" "[\W] » ")'
#else
#    PS1='$(printf "%*s\r%s" $(( COLUMNS-1 )) "[$(date +%H:%M)]" "[\W] » ")'
#fi

# Autorun
neofetch --w3m --source ~/Pictures/anonymous.png --size 500
