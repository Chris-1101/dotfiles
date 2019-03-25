#!/usr/bin/env bash

zsh_pid=$(tmux display-message -p '#{pane_pid}')
tmp="/tmp/zsh-vimode.$zsh_pid"

cat $tmp 2> /dev/null || echo "ins"
