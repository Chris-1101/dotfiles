# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#PS1='[\W] \033[0;32m»\033[0m'
#RPS1='$(git branch 2>/dev/null | grep "^*" | sed s/..//) [$(date +%H:%M)]'

PROMPT='[%l][%F{yellow}%1~%f] %F{green}»%f '
RPROMPT='[%F{magenta}%?%f][%D{%H:%M}]'
