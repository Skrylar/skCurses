
# TODO: Check if this is windows or linux; on windows we want PDCurses
# and on linux we want NCurses.

{.push hints: off.}
include skcurses.ncurses_h
{.pop}

# TODO: Consider stubbing the common calls here and using inlined
# forwarding functions, to make sure all "skcurses" calls are properly
# portable.

