# .dotfiles

* I run Arch on a high-DPI display. This may render my settings disproportionate on regular displays.
* The install script is one of my own making. It works, and there is some redundancy built in, but ultimately untested across different systems...  
Here be dragons! :dragon_face:

![August 2018 Rice: Terminals](https://user-images.githubusercontent.com/28808441/43341696-9384f5a4-91e0-11e8-99e8-a9da34ce3482.png)

<img src="https://user-images.githubusercontent.com/28808441/43340751-9f702440-91dd-11e8-9c57-046f975ed1dd.png" alt="August 2018 Rice: Lockscreen" width="208" height="117" /><img src="https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png" width="22" height="22" /><img src="https://user-images.githubusercontent.com/28808441/43340752-9f9d01f4-91dd-11e8-9594-f28f0e448c7c.png" alt="August 2018 Rice: Browser" width="208" height="117" /><img src="https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png" width="22" height="22" /><img src="https://user-images.githubusercontent.com/28808441/43340753-9fc291e4-91dd-11e8-9ba1-c576ec4b0fc9.png" alt="August 2018 Rice: Project Editor" width="208" height="117" /><img src="https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png" width="22" height="22" /><img src="https://user-images.githubusercontent.com/28808441/43340754-9fe479d0-91dd-11e8-98bd-6f8f7cf9c4b4.png" alt="August 2018 Rice: Split Editor" width="208" height="117" />

```
                      __   __               __   __
_____  ______ ______ |  | |__|_____ _____ _/  |_|__| ____   ____   ______
\__  \ \____ \\____ \|  | |  /  ___\\__  \\   __\  |/  _ \ /    \ /  ___/
 / __ \|  |_) |  |_) |  |_|  \  \___ / __ \|  | |  (  (_) )   |  \\___ \
(____  /   __/|   __/|____/__|\___  >____  /__| |__|\____/|___|  /____  >
     \/|__|   |__|                \/     \/                    \/     \/


Window Manager          » i3-gaps (compiled from cameronleger's feature-54-all branch)
Status Bar              » Polybar
Compositor              » Compton
Notification Daemon     » Dunst, Dunstify
Terminal Emulator       » URxvt
Terminal Font           » DejaVu Sans Mono (Nerd Font Patch)
Shell / CLI             » Z-Shell (custom prompt)
Application Launcher    » Rofi
CLI Editor              » Vim
Graphical Editor/IDE    » Atom
Browser                 » Firefox
Media Player            » mpv
System Monitor          » htop
System Information      » neofetch, inxi
File Manager            » Ranger, Nemo
Image Viewer            » feh
IRC Client              » WeeChat
Others                  » figlet, taskwarrior
```

### Using This Repository
If you're interested in using my dotfiles, please [fork](https://github.com/Chris-1101/dotfiles/fork) this repository before cloning it. These files contain cosmetic changes and workspace configurations that are entirely down to personal preference. Forking allows you to maintain your own separate repository.

### Install Script :warning:
Using the install script should be safe so long as you understand what's going on.
* Read the manual/help file first `install.sh -h`
* Read the script's prompts properly before typing `y` to continue
* Make sure you know which files are about to be overwritten, and back them up if needed.

##### To Do
* Make script backup existing files automatically

<!-- keybinds, notes on functionality (ctrl-t) -->

### Credits
* [Ares-II](https://github.com/Ares-II/Dotfiles): Firefox layout
* [GameHelp16](https://www.reddit.com/r/unixporn/comments/5tffxu/bspwm_polybar_trying_to_get_a_modern_look/): inspiration
* [f-s0ciety](https://www.deviantart.com/f-s0ciety): inspiration
* [Xero](https://github.com/xero/dotfiles): README zazz
