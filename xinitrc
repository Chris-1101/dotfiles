#!/bin/sh

#   ██╗  ██╗██╗███╗   ██╗██╗████████╗██████╗  ██████╗
#   ╚██╗██╔╝██║████╗  ██║██║╚══██╔══╝██╔══██╗██╔════╝
#    ╚███╔╝ ██║██╔██╗ ██║██║   ██║   ██████╔╝██║
#    ██╔██╗ ██║██║╚██╗██║██║   ██║   ██╔══██╗██║
#   ██╔╝ ██╗██║██║ ╚████║██║   ██║   ██║  ██║╚██████╗
#   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝

# install:set type=user path=$HOME/.xinitrc

# Path Definitions
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Merge Defaults & Keymaps
[[ -f $sysresources ]] && xrdb -merge "$sysresources"
[[ -f $sysmodmap ]] && xmodmap "$sysmodmap"
[[ -f $userresources ]] && xrdb -merge "$userresources"
[[ -f $usermodmap ]] && xmodmap "$usermodmap"

# Source Shell Scripts Found in xinitrc.d
if [[ -d /etc/X11/xinit/xinitrc.d ]] ; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [[ -x $f ]] && . "$f"
  done
  unset f
fi

# High DPI Settings
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5
# export QT_SCREEN_SCALE_FACTORS=0.5
# export QT_AUTO_SCREEN_SCALE_FACTOR=2
# export QT_SCALE_FACTOR=2
# xrandr --output eDP-1 --scale 1.5x1.5
# xrandr --output eDP-1 --panning 3200x1800

# Autorun
exec i3
