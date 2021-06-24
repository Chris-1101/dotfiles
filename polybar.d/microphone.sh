#!/usr/bin/env bash
#                    d8,                                   d8b
#                    `8P                                    ?88
#                                                            88b
#     88bd8b,d88b    88b  d8888b  88bd88b d8888b ?88,.d88b,  888888b   d8888b   88bd88b   d8888b
#     88P'`?8P'?8b   88P d8P' `P  88P'  `d8P' ?88`?88'  ?88  88P `?8b d8P' ?88  88P' ?8b d8b_,dP
#    d88  d88  88P  d88  88b     d88     88b  d88  88b  d8P d88   88P 88b  d88 d88   88P 88b
#   d88' d88'  88b d88'  `?888P'd88'     `?8888P'  888888P'd88'   88b` ?8888P'd88'   88b` ?888P'
#                                                  88P'
#                                                 d88    Polybar Module
#                                                ?8P
# ~/.config/polybar/microphone.sh

# Author       : Chris-1101 @ GitHub
# Description  : Displays microphone state
# Dependencies : amixer (ALSA)

# =================
# --- Functions ---
# =================

# Check Microphone Status
function check_mic_enabled
{
  amixer get Capture | grep '\[on\]'
}

# =================
# --- Execution ---
# =================

# Retrieve Microphone Status
status=$(check_mic_enabled)

# Output
if [[ -n $status ]]; then
  echo "%{T2}%{F#00DA90} %{F-}%{T-}%{T9}Active%{T-}"
else
  echo "%{T2}%{F#05ADFF}%{F-}%{T-}"
fi
