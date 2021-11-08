
#                  d8b
#                   ?88
#                    88b
#   d88888P  .d888b, 888888b   88bd88b d8888b
#      d8P'  ?8b,    88P `?8b  88P'  `d8P' `P
#    d8P'      `?8b d88   88P d88     88b
#   d88888P'`?888P'd88'   88bd88'     `?888P'

# ~/.zshrc

# =========================
# ------- Oh My ZSH -------
# =========================

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/usr/share/oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY="Default"
POWERLEVEL9K_VI_COMMAND_MODE_STRING="cmd \ue7c5"
POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND="black"
POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND="green"
POWERLEVEL9K_VI_INSERT_MODE_STRING="ins \ue7c5"
POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND="black"
POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND="cyan"
POWERLEVEL9K_STATUS_HIDE_SIGNAME="true"
POWERLEVEL9K_STATUS_OK_BACKGROUND=237
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir_writable dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time vi_mode)
POWERLEVEL9K_ROOT_ICON="\uF09C"
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"
POWERLEVEL9K_TIME_ICON=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(colored-man-pages command-not-found git sudo zsh-syntax-highlighting history-substring-search)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ============================
# ------- Run Commands -------
# ============================
runcom_dir=$HOME/.runcom

# Automatically Source Files
if [[ -d $runcom_dir ]]; then
  for file in "$runcom_dir"/*; do
    [[ -f $file ]] && source "$file"
  done
fi

# =================================
# ------- Directory Aliases -------
# =================================
hash -d dotfiles=$HOME/.dotfiles

if [[ -f $runcom_dir/dirs/peak.sh ]]; then
    source $runcom_dir/dirs/peak.sh
fi

# ==============================
# ------- Shell Settings -------
# ==============================
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

# History
HISTCONTROL=ignorespace
HISTFILE=~/.zsh_history
HISTSIZE=3000
SAVEHIST=10000

# Vim Mode
bindkey -v

# History Substring Search
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Auto cd
setopt autocd

# Auto Completion
autoload -Uz compinit && compinit

# ===================
# ------- AWS -------
# ===================
source ~/.aws/peakrc                # AWS Maven Bucket
source /usr/share/nvm/init-nvm.sh   # NodeJS Version Manager

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="/Users/chris/.sdkman"
# [[ -s "/Users/chris/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/chris/.sdkman/bin/sdkman-init.sh"
