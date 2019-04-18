
#   ███████╗███████╗██╗  ██╗██████╗  ██████╗
#   ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#     ███╔╝ ███████╗███████║██████╔╝██║
#    ███╔╝  ╚════██║██╔══██║██╔══██╗██║
#   ███████╗███████║██║  ██║██║  ██║╚██████╗
#   ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# install:set type=user path=$HOME/.zshrc

# =======================
# ------- Antigen -------
# =======================
source /usr/share/zsh/share/antigen.zsh

# Load oh-my-zsh Library
antigen use oh-my-zsh

# Load Plugins: https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

#antigen theme arclight

antigen apply

# Load Prompt Theme
source ~/.dotfiles/runcom/prompt/arclight.zsh-theme
ZLE_RPROMPT_INDENT=0

# ============================
# ------- Run Commands -------
# ============================
runcom_dir=$HOME/.dotfiles/runcom

# Automatically Source Files
if [[ -d $runcom_dir ]]; then
  for file in "$runcom_dir"/*; do
    [[ -f $file ]] && source "$file"
  done
fi

# Vi-Mode
zle -N zle-keymap-select

# Directory Navigation
zle -N dir-back
zle -N dir-parent
zle -N dir-save
zle -N dir-goto

# NOTE: Adding Functions to Zsh
# Zsh Line Editor -New function-name

# ==============================
# ------- Shell Settings -------
# ==============================
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Vim Mode
bindkey -v

# History Substring Search
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Directory Navigation
bindkey "^[$terminfo[kcub1]" dir-back
bindkey "^[$terminfo[kcuu1]" dir-parent
bindkey "^[$terminfo[kcud1]" dir-save
bindkey "^[$terminfo[kcuf1]" dir-goto

# Auto cd
setopt autocd

# Auto Completion
autoload -Uz compinit && compinit

# Source SSH Keys
test -f ~/.keychain/${HOST}-sh && source $_
