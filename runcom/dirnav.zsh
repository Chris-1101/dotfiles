#        ___ __
#     __| _/|__|______  ____ _____ ___  ___
#    / __ | |  \_  __ \/    \\__  \\  \/  /
#   / /_/ | |  ||  | \/   |  \/ __ \\    /
#   \____ | |__||__|  |___|  (____  /\__/   - shortcuts to facilitate directory navigation
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
save_loc=~/.cache/goto_dir

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
