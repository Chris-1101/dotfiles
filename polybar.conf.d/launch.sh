#!/usr/bin/env sh

#    __                              __      ___
#   |  | _____   __ __  ____   ____ |  |__   \_ |__ _____ _______  ______
#   |  | \__  \ |  |  \/    \_/ ___\|  |  \   | __ \\__  \\_  __ \/  ___/
#   |  |__/ __ \|  |  /   |  \  \___|   Y  \  | \_\ \/ __ \|  | \/\___ \
#   |____(____  /____/|___|  /\___  >___|  /  |___  (____  /__|  /____  >
#             \/           \/     \/     \/       \/     \/           \/

#?!:$HOME/.config/polybar/launch.sh

# Terminate any running instances of polybar
killall -q polybar

# Wait for polybar instances to be killed
while pgrep -u $UID -x polybar > /dev/null; do
  sleep 1
done

# Launch bars
polybar top &

polybar bottom &
ln -sf /tmp/polybar_mqueue.$! /tmp/ipc-btmbar

polybar systray &
ln -sf /tmp/polybar_mqueue.$! /tmp/ipc-systray
#ehco cmd:hide > /tmp/ipc-systray
