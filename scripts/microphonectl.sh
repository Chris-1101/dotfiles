#!/usr/bin/env bash
#                    d8,                                   d8b
#                    `8P                                    ?88
#                                                            88b
#     88bd8b,d88b    88b  d8888b  88bd88b d8888b ?88,.d88b,  888888b   d8888b   88bd88b   d8888b
#     88P'`?8P'?8b   88P d8P' `P  88P'  `d8P' ?88`?88'  ?88  88P `?8b d8P' ?88  88P' ?8b d8b_,dP
#    d88  d88  88P  d88  88b     d88     88b  d88  88b  d8P d88   88P 88b  d88 d88   88P 88b
#   d88' d88'  88b d88'  `?888P'd88'     `?8888P'  888888P'd88'   88b` ?8888P'd88'   88b` ?888P'
#                                                  88P'
#                                                 d88
#   ~/.local/bin/microphonectl                   ?8P

# Author       : Chris-1101 @ GitHub
# Description  : Toggles microphone capture state in ALSA - turns the thing on and off!
# Dependencies : amixer (ALSA), dunst, dunstify

# =================
# --- Functions ---
# =================

# Notifications
function notify
{
  local urgency='low'
  local header='Microphone Control'
  local icon='~/Pictures/Icons/mic.png'
  local -i id=90242

  case "$(get_mic_status)" in
    '[on]' ) local msg='Microphone enabled'  ;;
    '[off]') local msg='Microphone disabled' ;;
  esac

  dunstify -u "$urgency" "$header" "$msg" -i "$icon" -r $id
}

# Send Update to Polybar's IPC Queue
function trigger_polybar_hook
{
  /home/$USER/.local/bin/hookctl --polybar 'top' 'microphone'
}

# Toggle Microphone
function toggle_microphone
{
  amixer sset Capture toggle > /dev/null
}

# Microphone Status
function get_mic_status
{
  amixer get Capture | grep -o -e '\[on\]' -e '\[off\]' | head -n 1
}

# =================
# --- Execution ---
# =================

toggle_microphone
trigger_polybar_hook
notify
