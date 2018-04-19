from __future__ import (absolute_import, division, print_function)

from ranger.colorschemes.default import Default
from ranger.gui.color import cyan, magenta, blue, green


class Scheme(Default):

    def use(self, context):
        fg, bg, attr = Default.use(self, context)

        if context.border:
            fg = blue

        return fg, bg, attr
