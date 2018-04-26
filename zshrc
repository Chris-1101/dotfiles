#                   __
#   ________  _____|  |_________   ____
#   \___   / /  ___/  |  \_  __ \_/ ___\
#    /    /  \___ \|   Y  \  | \/\  \___
#   /_____ \/____  >___|  /__|    \___  >
#         \/     \/     \/            \/

#?!: $HOME/.zshrc

# =======================
# ------- Antigen -------
# =======================
source /usr/share/zsh/share/antigen.zsh

# Load oh-my-zsh Library
antigen use oh-my-zsh

# Default Repo Plugins: https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting

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

# Enable Auto cd
setopt autocd

# Enable Auto Completion
autoload -Uz compinit && compinit
