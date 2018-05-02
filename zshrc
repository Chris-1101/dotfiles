
#   ███████╗███████╗██╗  ██╗██████╗  ██████╗
#   ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#     ███╔╝ ███████╗███████║██████╔╝██║
#    ███╔╝  ╚════██║██╔══██║██╔══██╗██║
#   ███████╗███████║██║  ██║██║  ██║╚██████╗
#   ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

#?!:$HOME/.zshrc

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
source ~/.dotfiles/runcom/arclight.zsh-theme

# ============================
# ------- Run Commands -------
# ============================
runcom_dir=$HOME/.dotfiles/runcom

# Automatically Source Files
if [[ -d $runcom_dir ]]; then
    for file in "$runcom_dir"/*; do
        [[ -f $file ]] && source $file
    done
fi

# Zsh Line Editor - New Keymaps
zle -N dir-back
zle -N dir-parent
zle -N dir-save
zle -N dir-goto

# ==============================
# ------- Shell Settings -------
# ==============================
# The following lines were added by compinstall
#zstyle :compinstall filename '$HOME/.zshrc'

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# History Substring Search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Directory Navigation
bindkey '^[^[[D' dir-back
bindkey '^[^[[A' dir-parent
bindkey '^[^[[B' dir-save
bindkey '^[^[[C' dir-goto

# Vim Mode
bindkey -v

# Auto cd
setopt autocd

# Auto Completion
autoload -Uz compinit && compinit

# ========================
# ------- Auto Run -------
# ========================
neofetch
