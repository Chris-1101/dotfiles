#!/usr/bin/env bash

#    __                              __      ___
#   |  | _____   __ __  ____  _____ |  |__   \_ |__ _____ _______  ______
#   |  | \__  \ |  |  \/    \/  ___\|  |  \   | __ \\__  \\_  __ \/  ___/
#   |  |__/ __ \|  |  /   |  \  \___|   Y  \  | \_\ \/ __ \|  | \/\___ \
#   |____(____  /____/|___|  /\___  >___|  /  |___  (____  /__|  /____  >
#             \/           \/     \/     \/       \/     \/           \/

# install:set type=user path=$HOME/.config/polybar/launch.sh

# Terminate any running instances of polybar
killall -q polybar

# Wait for polybar instances to be killed
while pgrep -u $UID -x polybar > /dev/null; do
  sleep 2
done

# Launch bars
polybar top &

polybar bottom &
ln -sf /tmp/polybar_mqueue.$! /tmp/ipc-btmbar

polybar systray &
ln -sf /tmp/polybar_mqueue.$! /tmp/ipc-systray
