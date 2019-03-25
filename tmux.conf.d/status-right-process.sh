#!/usr/bin/env bash

zsh_pid=$(tmux display-message -p '#{pane_pid}')

ps -p $zsh_pid -o comm=
