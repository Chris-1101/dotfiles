#!/usr/bin/env sh

# Terminate any running instances of polybar
killall -q polybar

# Wait for the above command to complete
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bars
polybar top &
polybar bottom &
polybar systray &

# Create IPC symlink for System Tray and hide on launch
ln -sf /tmp/polybar_mqueue.$! /tmp/ipc-systray
#ehco cmd:hide > /tmp/ipc-systray

echo "Polybar loaded"
