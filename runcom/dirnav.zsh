#        ___ __
#     __| _/|__|______  ____ _____ ___  __
#    / __ | |  \_  __ \/    \\__  \\  \/ /
#   / /_/ | |  ||  | \/   |  \/ __ \\   /
#   \____ | |__||__|  |___|  (____  /\_/   - shortcuts to facilitate directory navigation
#        \/                \/     \/

# atom:set grammar=sh

# Back & Print Directory Stack
function dir-back
{
    popd
    zle reset-prompt
}

# Up & Push Directory to Stack
function dir-parent
{
    pushd ..
    zle reset-prompt
}

# Save Location
save_loc=~/.goto_dir

# Save Working Directory
function dir-save
{
    pwd > $save_loc
}

# Go to Saved Directory
function dir-goto
{
    pushd "$(cat $save_loc)"
    zle reset-prompt
}
