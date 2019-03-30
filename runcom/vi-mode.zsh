# Executed Every Vi-Mode Change
function zle-keymap-select
{
  # Set temp file location and include caller shell's PID
  local tmp="/tmp/zsh-vimode.$$"

  # Create temp file if it doesn't exist and ignore mktemp's template warnings
  [[ ! -e $tmp ]] && mktemp $tmp 2> /dev/null

  # Save current vi-mode to temporary file
  echo ${${KEYMAP/vicmd/cmd}/(main|viins)/ins} > "$tmp"

  # Resfresh Tmux
  sleep 0.1 && tmux refresh-client 2> /dev/null
}
