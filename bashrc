
#   ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
#   ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
#   ██████╔╝███████║███████╗███████║██████╔╝██║
#   ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║
#   ██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
#   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# install:set type=user path=$HOME/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source Run Command Files
runcom_dir=$HOME/.dotfiles/runcom

if [[ -d $runcom_dir ]]; then
  for file in "$runcom_dir"/*; do
    [[ -f $file && $file != *"zsh"* ]] && source "$file"
  done
fi

# Source SSH Keys
test -f ~/.keychain/${HOSTNAME}-sh && source $_

# Shell Prompt
PS1='$(printf "%*s\r%s" $(( COLUMNS-1 )) "$(git branch 2>/dev/null | grep '^*' | sed s/..//) [$(date +%H:%M)]" "[\W] \033[0;32m»\033[0m ")'

# Powerline
#powerline-daemon -q
#POWERLINE_BASH_CONTINUATION=1
#POWERLINE_BASH_SELECT=1
#. /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
