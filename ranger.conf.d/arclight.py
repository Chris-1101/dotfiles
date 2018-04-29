#                         __   __        __     __
#   _____ _______   ____ |  | |__| ____ |  |___/  |_
#   \__  \\_  __ \_/ ___\|  | |  |/ ___\|  |  \   __\
#    / __ \|  | \/\  \___|  |_|  / /_/  >   Y  \  |
#   (____  /__|    \___  >____/__\___  /|___|  /__|
#        \/            \/       /_____/      \/

#?!:$HOME/.config/ranger/colorschemes/arclight.py

from __future__ import (absolute_import, division, print_function)

from ranger.colorschemes.default import Default
from ranger.gui.color import blue

# Use Default Scheme
class Scheme(Default):

    def use(self, context):
        fg, bg, attr = Default.use(self, context)

        if context.border:
            fg = blue

        return fg, bg, attr
