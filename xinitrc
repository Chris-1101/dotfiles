
#             d8,           d8,
#             `8P           `8P   d8P
#                              d888888P
#   ?88,  88P  88b 88bd88b   88b ?88'   88bd88b d8888b
#    `?8bd8P'  88P 88P' ?8b  88P 88P    88P'  `d8P' `P
#    d8P?8b,  d88 d88   88P d88  88b   d88     88b
#   d8P' `?8bd88'd88'   88bd88'  `?8b d88'     `?888P'

# ~/.xinitrc

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

# Source Scripts Found in xinitrc.d
if [[ -d /etc/X11/xinit/xinitrc.d ]]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [[ -x $f ]] && . "$f"
  done
  unset f
fi

# Export GNOME Session Type
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
#exec gnome-session

# Execute Default X.org WM
#twm &
#xclock -geometry 50x50-1+1 &
#xterm -geometry 80x50+494+51 &
#xterm -geometry 80x20+494-0 &
#exec xterm -geometry 80x66+0+0 -name login
