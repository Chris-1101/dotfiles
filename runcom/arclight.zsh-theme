#                  __                               __   __        __     __
#   ________ _____|  |__      _____ _______  _____ |  | |__| ____ |  |___/  |_
#   \___   //  ___/  |  \ ____\__  \\_  __ \/  ___\|  | |  |/ ___\|  |  \   __\
#    /  __/ \___ \|   Y  \ ___ / __ \|  | \/\  \___|  |_|  / /_/  >   Y  \  |
#   /_____ \____  >___|  /    (____  /__|    \___  >____/__\___  /|___|  /__|
#         \/    \/     \/          \/            \/       (_____/      \/

# atom:set grammar=sh

# ==============================
# ------- Git Formatting -------
# ==============================
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✓%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}△%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}◒%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➜%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%}▲%{$reset_color%} "

# ================================
# ------- Left-Hand Prompt -------
# ================================
local working_dir="[%{$fg[cyan]%}%1~%{$reset_color%}]"
local exit_code="%{$fg[red]%}%(?..%? )%{$reset_color%}"
local prompt_char="%{$fg[green]%}»%{$reset_color%}"

PROMPT='${working_dir} ${exit_code}${prompt_char} ' # ┌╼ └───╼➤

# =================================
# ------- Right-Hand Prompt -------
# =================================
function git_prompt_right()
{
  local branch=$(current_branch)

  if [ -n "$branch" ]; then
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$branch$ZSH_THEME_GIT_PROMPT_SUFFIX %{$fg[yellow]%}$(git_prompt_short_sha)%{$reset_color%}"
  fi
}

local time="[%D{%H:%M}]"
local term_session="%{$fg[magenta]%}$(print -P %l | sed s/"pts\/"//)%{$reset_color%}"

RPROMPT='$(git_prompt_status)$(git_prompt_right) ${time} ${term_session}'
