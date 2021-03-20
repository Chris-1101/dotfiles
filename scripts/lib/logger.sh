
# Author: Chris MB
# Description: Logs to controlling terminal's stdout if present, or to systemd's journal
# Requirements: Expects a variable `script_name` to be defined

function logger
{
  if [[ -t 1 ]]; then
    shift && printf '%s\n' "$@"
  else
    systemd-cat -p info -t $script_name <<< "$@"
  fi
}
