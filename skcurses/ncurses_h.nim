#****************************************************************************
#   Copyright (c) 1998-2010,2011 Free Software Foundation, Inc.
#
#   Permission is hereby granted, free of charge, to any person obtaining a
#   copy of this software and associated documentation files (the
#   "Software"), to deal in the Software without restriction, including
#   without limitation the rights to use, copy, modify, merge, publish,
#   distribute, distribute with modifications, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included
#   in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
#   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#   IN NO EVENT SHALL THE ABOVE COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
#   DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
#   OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
#   THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#   Except as contained in this notice, the name(s) of the above copyright
#   holders shall not be used in advertising or otherwise to promote the
#   sale, use or other dealings in this Software without prior written
#   authorization.
#****************************************************************************

#****************************************************************************
#   Author: Zeyd M. Ben-Halim <zmbenhal@netcom.com> 1992,1995
#      and: Eric S. Raymond <esr@snark.thyrsus.com>
#      and: Thomas E. Dickey                        1996-on
#****************************************************************************

# $Id: curses.h.in,v 1.220 2011/01/22 19:47:20 tom Exp $

# I don't want to be prodded about line length for this module
{.push hints: off.}

import unsigned

type
  Pcushort = ptr cushort
  Pcshort = ptr cshort

const
  # These are defined only in curses.h, and are used for conditional compiles
  VersionMajor* = 5
  VersionMinor* = 9
  VersionPatch* = 20110404

  # This is defined in more than one ncurses header, for identification
  Version* = "5.9"

  # Identify the mouse encoding version.
  MouseVersion* = 1

  # Definitions to facilitate DLL's.
  Header = "<ncurses_dll.h>"

  # User-definable tweak to disable the include of <stdbool.h>.
  EnableStdboolH = 1

  # NCURSES_ATTR_T is used to quiet compiler warnings when building ncurses
  # configured using --disable-macros.

type
  # TAttr* = cint -- declared later

  # Expands to 'const' if ncurses is configured using --enable-const.  Note that
  # doing so makes it incompatible with other implementations of X/Open Curses.

  #undef  NCURSES_CONST
  #define NCURSES_CONST const

  #undef NCURSES_INLINE
  #define NCURSES_INLINE inline

  # The internal type used for color values
  TColor* = cshort

const
  # Definition used to make WINDOW and similar structs opaque.
  Opaque* = 0

  # The reentrant code relies on the opaque setting, but adds features.
  Reentrant* = 0

  # Control whether bindings for interop support are added.
  InteropFuncs* = 0

type
  # The internal type used for window dimensions.
  TSize* = cshort

const
  # Control whether tparm() supports varargs or fixed-parameter list.
  TparmVarargs* = 1

  # NCURSES_CH_T is used in building the library, but not used otherwise in
  # this header file, since that would make the normal/wide-character versions
  # of the header incompatible.
  # Tch* = TChtype

type
  #if 0 && defined(_LP64)
  #typedef unsigned chtype;
  #typedef unsigned mmask_t;
  #else
  PChtype* = ptr TChtype
  TChtype* = culong
  TMMask*  = culong
  #endif

  # We need FILE, etc.  Include this before checking any feature symbols.
  #include <stdio.h>

  # TODO {{{

  # With XPG4, you must define _XOPEN_SOURCE_EXTENDED, it is redundant (or
  # conflicting) when _XOPEN_SOURCE is 500 or greater.
  #undef NCURSES_WIDECHAR
  #if defined(_XOPEN_SOURCE_EXTENDED) || defined(_XPG5)
  #define NCURSES_WIDECHAR
  #endif

  #include <stdarg.h>	/* we need va_list */
  #ifdef NCURSES_WIDECHAR
  #include <stddef.h>	/* we want wchar_t */
  #endif

  # }}}

  # X/Open and SVr4 specify that curses implements 'bool'.  However, C++ may also
  # implement it.  If so, we must use the C++ compiler's type to avoid conflict
  # with other interfaces.
  #
  # A further complication is that <stdbool.h> may declare 'bool' to be a
  # different type, such as an enum which is not necessarily compatible with
  # C++.  If we have <stdbool.h>, make 'bool' a macro, so users may #undef it.
  # Otherwise, let it remain a typedef to avoid conflicts with other #define's.
  # In either case, make a typedef for NCURSES_BOOL which can be used if needed
  # from either C or C++.

  TNcursesBool* = cuchar

  #if defined(__cplusplus)	/* __cplusplus, etc. */

  # TODO we're not using C++ by default, but someone might use the C++
  # target with this binding...

  # {{{

  # use the C++ compiler's bool type
  #define NCURSES_BOOL bool

  #else			/* c89, c99, etc. */

  #if NCURSES_ENABLE_STDBOOL_H
  #include <stdbool.h>
  # use whatever the C compiler decides bool really is
  #define NCURSES_BOOL bool
  #else
  # there is no predefined bool - use our own
  #undef bool
  #define bool NCURSES_BOOL
  #endif

  #endif /* !__cplusplus, etc. */

  # }}}

# X/Open attributes.  In the ncurses implementation, they are identical to the
# A_ attributes.

# TODO: These are actually defined later in the file...
template WA_ATTRIBUTES * () = A_ATTRIBUTES
template WA_NORMAL     * () = A_NORMAL
template WA_STANDOUT   * () = A_STANDOUT
template WA_UNDERLINE  * () = A_UNDERLINE
template WA_REVERSE    * () = A_REVERSE
template WA_BLINK      * () = A_BLINK
template WA_DIM        * () = A_DIM
template WA_BOLD       * () = A_BOLD
template WA_ALTCHARSET * () = A_ALTCHARSET
template WA_INVIS      * () = A_INVIS
template WA_PROTECT    * () = A_PROTECT
template WA_HORIZONTAL * () = A_HORIZONTAL
template WA_LEFT       * () = A_LEFT
template WA_LOW        * () = A_LOW
template WA_RIGHT      * () = A_RIGHT
template WA_TOP        * () = A_TOP
template WA_VERTICAL   * () = A_VERTICAL

const
  # colors
  COLOR_BLACK   * = 0
  COLOR_RED     * = 1
  COLOR_GREEN   * = 2
  COLOR_YELLOW  * = 3
  COLOR_BLUE    * = 4
  COLOR_MAGENTA * = 5
  COLOR_CYAN    * = 6
  COLOR_WHITE   * = 7

# line graphics

#if 0 || NCURSES_REENTRANT
#NCURSES_WRAPPED_VAR(chtype*, acs_map);
#define acs_map NCURSES_PUBLIC_VAR(acs_map())
#else
var AcsMap* {.nodecl, exportc: "acs_map".}: array[0..10000, TChtype]
#endif

template Acs*(c: cuchar) =
  acs_map[c]

# VT100 symbols begin here
template ACS_ULCORNER() = # upper left corner
  NCURSES_ACS('l')
template ACS_LLCORNER() = # lower left corner
  NCURSES_ACS('m')
template ACS_URCORNER() = # upper right corner
  NCURSES_ACS('k')
template ACS_LRCORNER() = # lower right corner
  NCURSES_ACS('j')
template ACS_LTEE()     = # tee pointing right
  NCURSES_ACS('t')
template ACS_RTEE()     = # tee pointing left
  NCURSES_ACS('u')
template ACS_BTEE()     = # tee pointing up
  NCURSES_ACS('v')
template ACS_TTEE()     = # tee pointing down
  NCURSES_ACS('w')
template ACS_HLINE()    = # horizontal line
  NCURSES_ACS('q')
template ACS_VLINE()    = # vertical line
  NCURSES_ACS('x')
template ACS_PLUS()     = # large plus or crossover
  NCURSES_ACS('n')
template ACS_S1()       = # scan line 1
  NCURSES_ACS('o')
template ACS_S9()       = # scan line 9
  NCURSES_ACS('s')
template ACS_DIAMOND()  = # diamond
  NCURSES_ACS('`')
template ACS_CKBOARD()  = # checker board(stipple)
  NCURSES_ACS('a')
template ACS_DEGREE()   = # degree symbol
  NCURSES_ACS('f')
template ACS_PLMINUS()  = # plus/minus
  NCURSES_ACS('g')
template ACS_BULLET()   = # bullet
  NCURSES_ACS('~')

# Teletype 5410v1 symbols begin here
template ACS_LARROW()  = # arrow pointing left
  NCURSES_ACS(',')
template ACS_RARROW()  = # arrow pointing right
  NCURSES_ACS('+')
template ACS_DARROW()  = # arrow pointing down
  NCURSES_ACS('.')
template ACS_UARROW()  = # arrow pointing up
  NCURSES_ACS('-')
template ACS_BOARD()   = # board of squares
  NCURSES_ACS('h')
template ACS_LANTERN() = # lantern symbol
  NCURSES_ACS('i')
template ACS_BLOCK()   = # solid square block
  NCURSES_ACS('0')

# These aren't documented, but a lot of System Vs have them anyway
#(you can spot pprryyzz{{||}} in a lot of AT&T terminfo strings).
# The ACS_names may not match AT&T's, our source didn't know them.
template ACS_S3()       = # scan line 3
  NCURSES_ACS('p')
template ACS_S7()       = # scan line 7
  NCURSES_ACS('r')
template ACS_LEQUAL()   = # less/equal
  NCURSES_ACS('y')
template ACS_GEQUAL()   = # greater/equal
  NCURSES_ACS('z')
template ACS_PI()       = # Pi
  NCURSES_ACS('{')
template ACS_NEQUAL()   = # not equal
  NCURSES_ACS('|')
template ACS_STERLING() = # UK pound sign
  NCURSES_ACS('}')

# Line drawing ACS names are of the form ACS_trbl, where t is the top, r
# is the right, b is the bottom, and l is the left.  t, r, b, and l might
# be B (blank), S (single), D (double), or T (thick).  The subset defined
# here only uses B and S.
template ACS_BSSB() = ACS_ULCORNER
template ACS_SSBB() = ACS_LLCORNER
template ACS_BBSS() = ACS_URCORNER
template ACS_SBBS() = ACS_LRCORNER
template ACS_SBSS() = ACS_RTEE
template ACS_SSSB() = ACS_LTEE
template ACS_SSBS() = ACS_BTEE
template ACS_BSSS() = ACS_TTEE
template ACS_BSBS() = ACS_HLINE
template ACS_SBSB() = ACS_VLINE
template ACS_SSSS() = ACS_PLUS

const
  ERR * = (-1)
  OK  * = (0)

  # values for the _flags member
  #_SUBWIN    * = 0x01 # is this a sub-window?
  #_ENDLINE   * = 0x02 # is the window flush right?
  #_FULLWIN   * = 0x04 # is the window full-screen?
  #_SCROLLWIN * = 0x08 # bottom edge is at screen bottom?
  #_ISPAD     * = 0x10 # is this window a pad?
  #_HASMOVED  * = 0x20 # has cursor moved since last refresh?
  #_WRAPPED   * = 0x40 # cursor was just wrappped

  ## this value is used in the firstchar and lastchar fields to mark
  ## unchanged lines
  #_NOCHANGE* = -1

  ## this value is used in the oldindex field to mark lines created by insertions
  ## and scrolls.
  #_NEWINDEX* = -1

type
  #TScreen* = object {.nodecl, importc: "struct screen".}
  #TWindow* = object {.nodecl, importc: "struct _win_st".}
  PScreen* {.importc: "SCREEN *".} = distinct pointer
  PWindow* {.importc: "WINDOW *".} = distinct pointer

  TAttr* = TChtype
  PAttr* = ptr TAttr

#ifdef NCURSES_WIDECHAR {{{

##if 0
##ifdef mblen			/* libutf8.h defines it w/o undefining first */
##undef mblen
##endif
##include <libutf8.h>
##endif
#
##if 0
##include <wchar.h>		/* ...to get mbstate_t, etc. */
##endif
#
##if 0
#typedef unsigned short wchar_t;
##endif
#
##if 0
#typedef unsigned int wint_t;
##endif
#
#/*
# * cchar_t stores an array of CCHARW_MAX wide characters.  The first is
# * normally a spacing character.  The others are non-spacing.  If those
# * (spacing and nonspacing) do not fill the array, a null L'\0' follows.
# * Otherwise, a null is assumed to follow when extracting via getcchar().
# */
##define CCHARW_MAX	5
#typedef struct
#{
#    attr_t	attr;
#    wchar_t	chars[CCHARW_MAX];
##if 0
##undef NCURSES_EXT_COLORS
##define NCURSES_EXT_COLORS 20110404
#    int		ext_color;	/* color pair, must be more than 16-bits */
##endif
#}
#cchar_t;

#endif /* NCURSES_WIDECHAR */
#}}}

#if !NCURSES_OPAQUE {{{
#struct ldat;
#
#struct _win_st
#{
#	NCURSES_SIZE_T _cury, _curx; /* current cursor position */
#
#	/* window location and size */
#	NCURSES_SIZE_T _maxy, _maxx; /* maximums of x and y, NOT window size */
#	NCURSES_SIZE_T _begy, _begx; /* screen coords of upper-left-hand corner */
#
#	short   _flags;		/* window state flags */
#
#	/* attribute tracking */
#	attr_t  _attrs;		/* current attribute for non-space character */
#	chtype  _bkgd;		/* current background char/attribute pair */
#
#	/* option values set by user */
#	bool	_notimeout;	/* no time out on function-key entry? */
#	bool	_clear;		/* consider all data in the window invalid? */
#	bool	_leaveok;	/* OK to not reset cursor on exit? */
#	bool	_scroll;	/* OK to scroll this window? */
#	bool	_idlok;		/* OK to use insert/delete line? */
#	bool	_idcok;		/* OK to use insert/delete char? */
#	bool	_immed;		/* window in immed mode? (not yet used) */
#	bool	_sync;		/* window in sync mode? */
#	bool	_use_keypad;	/* process function keys into KEY_ symbols? */
#	int	_delay;		/* 0 = nodelay, <0 = blocking, >0 = delay */
#
#	struct ldat *_line;	/* the actual line data */
#
#	/* global screen state */
#	NCURSES_SIZE_T _regtop;	/* top line of scrolling region */
#	NCURSES_SIZE_T _regbottom; /* bottom line of scrolling region */
#
#	/* these are used only if this is a sub-window */
#	int	_parx;		/* x coordinate of this window in parent */
#	int	_pary;		/* y coordinate of this window in parent */
#	WINDOW	*_parent;	/* pointer to parent if a sub-window */
#
#	/* these are used only if this is a pad */
#	struct pdat
#	{
#	    NCURSES_SIZE_T _pad_y,      _pad_x;
#	    NCURSES_SIZE_T _pad_top,    _pad_left;
#	    NCURSES_SIZE_T _pad_bottom, _pad_right;
#	} _pad;
#
#	NCURSES_SIZE_T _yoffset; /* real begy is _begy + _yoffset */
#
##ifdef NCURSES_WIDECHAR
#	cchar_t  _bkgrnd;	/* current background char/attribute pair */
##if 0
#	int	_color;		/* current color-pair for non-space character */
##endif
##endif
#};
#endif /* NCURSES_OPAQUE */
#}}}

# This is an extension to support events...

#if 1
#ifdef NCURSES_WGETCH_EVENTS
#if !defined(__BEOS__) || defined(__HAIKU__)

# Fix _nc_timed_wait() on BEOS...

#  define NCURSES_EVENT_VERSION	1
#endif	/* !defined(__BEOS__) */

# Bits to set in _nc_event.data.flags
#_NC_EVENT_TIMEOUT_MSEC  * = 1
#_NC_EVENT_FILE          * = 2
#_NC_EVENT_FILE_READABLE * = 2

#  if 0 /* Not supported yet... */
#    define _NC_EVENT_FILE_WRITABLE	4
#    define _NC_EVENT_FILE_EXCEPTION	8
#  endif

# TODO {{{

#typedef struct
#{
#    int type;
#    union
#    {
#	long timeout_msec;	/* _NC_EVENT_TIMEOUT_MSEC */
#	struct
#	{
#	    unsigned int flags;
#	    int fd;
#	    unsigned int result;
#	} fev;				/* _NC_EVENT_FILE */
#    } data;
#} _nc_event;
#
#typedef struct
#{
#    int count;
#    int result_flags;	/* _NC_EVENT_TIMEOUT_MSEC or _NC_EVENT_FILE_READABLE */
#    _nc_event *events[1];
#} _nc_eventlist;
#
#extern NCURSES_EXPORT(int) wgetch_events (WINDOW *, _nc_eventlist *);	/* experimental */
#extern NCURSES_EXPORT(int) wgetnstr_events (WINDOW *,char *,int,_nc_eventlist *);/* experimental */
#
##endif /* NCURSES_WGETCH_EVENTS */
##endif /* NCURSES_EXT_FUNCS */

# }}}

# GCC (and some other compilers) define '__attribute__'; we're using this
# macro to alert the compiler to flag inconsistencies in printf/scanf-like
# function calls.  Just in case '__attribute__' isn't defined, make a dummy.
# Old versions of G++ do not accept it anyway, at least not consistently with
# GCC.

#if !(defined(__GNUC__) || defined(__GNUG__) || defined(__attribute__))
#define __attribute__(p) /* nothing */
#endif

# We cannot define these in ncurses_cfg.h, since they require parameters to be
# passed (that is non-portable).  If you happen to be using gcc with warnings
# enabled, define
#	GCC_PRINTF
#	GCC_SCANF
# to improve checking of calls to printw(), etc.

# TODO do something with these {{{

#ifndef GCC_PRINTFLIKE
#if defined(GCC_PRINTF) && !defined(printf)
#define GCC_PRINTFLIKE(fmt,var) __attribute__((format(printf,fmt,var)))
#else
#define GCC_PRINTFLIKE(fmt,var) /*nothing*/
#endif
#endif

#ifndef GCC_SCANFLIKE
#if defined(GCC_SCANF) && !defined(scanf)
#define GCC_SCANFLIKE(fmt,var)  __attribute__((format(scanf,fmt,var)))
#else
#define GCC_SCANFLIKE(fmt,var)  /*nothing*/
#endif
#endif

#ifndef	GCC_NORETURN
#define	GCC_NORETURN /* nothing */
#endif

#ifndef	GCC_UNUSED
#define	GCC_UNUSED /* nothing */
#endif

# }}}

# TODO this is probably really useful {{{
# Curses uses a helper function.  Define our type for this to simplify
# extending it for the sp-funcs feature.
# typedef int (*NCURSES_OUTC)(int);
# }}}

# Function prototypes.  This is the complete X/Open Curses list of required
# functions.  Those marked `generated' will have sources generated from the
# macro definitions later in this file, in order to satisfy XPG4.2
# requirements.

# TODO clean up the nimrod naming for these {{{

proc addch *(TChtype): cint {.discardable, nodecl, importc:"addch".}
proc addchnstr *(PChtype, cint): cint {.discardable, nodecl, importc:"addchnstr".}
proc addchstr *(PChtype): cint {.discardable, nodecl, importc:"addchstr".}
proc addnstr *(cstring, cint): cint {.discardable, nodecl, importc:"addnstr".}
proc addstr *(cstring): cint {.discardable, nodecl, importc:"addstr".}
proc attroff *(TAttr): cint {.discardable, nodecl, importc:"attroff".}
proc attron *(TAttr): cint {.discardable, nodecl, importc:"attron".}
proc attrset *(TAttr): cint {.discardable, nodecl, importc:"attrset".}
proc attr_get *(PAttr, pcshort, PVoid): cint {.discardable, nodecl, importc:"attr_get".}
proc attr_off *(TAttr, PVoid): cint {.discardable, nodecl, importc:"attr_off".}
proc attr_on *(TAttr, PVoid): cint {.discardable, nodecl, importc:"attr_on".}
proc attr_set *(TAttr, cshort, PVoid): cint {.discardable, nodecl, importc:"attr_set".}
proc baudrate *(): cint {.discardable, nodecl, importc:"baudrate".}
proc beep  *(): cint {.discardable, nodecl, importc:"beep ".}
proc bkgd *(TChtype): cint {.discardable, nodecl, importc:"bkgd".}
proc bkgdset *(TChtype) {.discardable, nodecl, importc:"bkgdset".}
proc border *(a,b,c,d,e,f,g,h: TChtype): cint {.discardable, nodecl, importc:"border".}
proc box *(PWindow; a, b: TChtype): cint {.discardable, nodecl, importc:"box".}
proc can_change_color *(): bool {.discardable, nodecl, importc:"can_change_color".}
proc cbreak *(): cint {.discardable, nodecl, importc:"cbreak".}
proc chgat *(cint, TAttr, cshort, PVoid): cint {.discardable, nodecl, importc:"chgat".}
proc clear *(): cint {.discardable, nodecl, importc:"clear".}
proc clearok *(PWindow,bool): cint {.discardable, nodecl, importc:"clearok".}
proc clrtobot *(): cint {.discardable, nodecl, importc:"clrtobot".}
proc clrtoeol *(): cint {.discardable, nodecl, importc:"clrtoeol".}
proc color_content *(cshort;a,b,c:pcshort): cint {.discardable, nodecl, importc:"color_content".}
proc color_set *(cshort,PVoid): cint {.discardable, nodecl, importc:"color_set".}
proc COLOR_PAIR *(cint): cint {.discardable, nodecl, importc:"COLOR_PAIR".}
proc copywin*(i,j: PWindow; a,b,c,d,e,f,g:cint): cint {.discardable, nodecl, importc:"copywin".}
proc curs_set *(cint): cint {.discardable, nodecl, importc:"curs_set".}
proc def_prog_mode *(): cint {.discardable, nodecl, importc:"def_prog_mode".}
proc def_shell_mode *(): cint {.discardable, nodecl, importc:"def_shell_mode".}
proc delay_output *(cint): cint {.discardable, nodecl, importc:"delay_output".}
proc delch *(): cint {.discardable, nodecl, importc:"delch".}
proc delscreen *(PScreen) {.discardable, nodecl, importc:"delscreen".}
proc delwin *(PWindow): cint {.discardable, nodecl, importc:"delwin".}
proc deleteln *(): cint {.discardable, nodecl, importc:"deleteln".}
proc derwin *(zz: PWindow;aa,bb,cc,dd: cint): PWindow {.discardable, nodecl, importc:"derwin".}
proc doupdate *(): cint {.discardable, nodecl, importc:"doupdate".}
proc dupwin *(PWindow): PWindow {.discardable, nodecl, importc:"dupwin".}
proc echo *(): cint {.discardable, nodecl, importc:"echo".}
proc echochar *(TChtype): cint {.discardable, nodecl, importc:"echochar".}
proc erase *(): cint {.discardable, nodecl, importc:"erase".}
proc endwin *(): cint {.discardable, nodecl, importc:"endwin".}
proc erasechar *(): char {.discardable, nodecl, importc:"erasechar".}
proc filter *() {.discardable, nodecl, importc:"filter".}
proc flash *(): cint {.discardable, nodecl, importc:"flash".}
proc flushinp *(): cint {.discardable, nodecl, importc:"flushinp".}
proc getbkgd *(PWindow): TChtype {.discardable, nodecl, importc:"getbkgd".}
proc getch *(): cint {.discardable, nodecl, importc:"getch".}
proc getnstr *(cstring, cint): cint {.discardable, nodecl, importc:"getnstr".}
proc getstr *(cstring): cint {.discardable, nodecl, importc:"getstr".}

# TODO getwin *(FILE *): PWindow ;# implemented

proc halfdelay *(cint): cint {.discardable, nodecl, importc:"halfdelay".}# implemented
proc has_colors *(): bool {.discardable, nodecl, importc:"has_colors".}# implemented
proc has_ic *(): bool {.discardable, nodecl, importc:"has_ic".}# implemented
proc has_il *(): bool {.discardable, nodecl, importc:"has_il".}# implemented
proc hline *(TChtype, cint): cint {.discardable, nodecl, importc:"hline".}# generated
proc idcok *(PWindow, bool) {.discardable, nodecl, importc:"idcok".}# implemented
proc idlok *(PWindow, bool): cint {.discardable, nodecl, importc:"idlok".}# implemented
proc immedok *(PWindow, bool) {.discardable, nodecl, importc:"immedok".}# implemented
proc inch *(): TChtype {.discardable, nodecl, importc:"inch".}# generated
proc inchnstr *(PChtype, cint): cint {.discardable, nodecl, importc:"inchnstr".}# generated
proc inchstr *(PChtype): cint {.discardable, nodecl, importc:"inchstr".}# generated
proc initscr *(): PWindow {.discardable, nodecl, importc:"initscr".}# implemented
proc init_color *(a,b,c,d:cshort): cint {.discardable, nodecl, importc:"init_color".}# implemented
proc init_pair *(a, b, c: cshort): cint {.discardable, nodecl, importc:"init_pair".}# implemented
proc innstr *(cstring, cint): cint {.discardable, nodecl, importc:"innstr".}# generated
proc insch *(TChtype): cint {.discardable, nodecl, importc:"insch".}# generated
proc insdelln *(cint): cint {.discardable, nodecl, importc:"insdelln".}# generated
proc insertln *(): cint {.discardable, nodecl, importc:"insertln".}# generated
proc insnstr *(cstring, cint): cint {.discardable, nodecl, importc:"insnstr".}# generated
proc insstr *(cstring): cint {.discardable, nodecl, importc:"insstr".}# generated
proc instr *(cstring): cint {.discardable, nodecl, importc:"instr".}# generated
proc cintrflush *(PWindow,bool): cint {.discardable, nodecl, importc:"cintrflush".}# implemented
proc isendwin *(): bool {.discardable, nodecl, importc:"isendwin".}# implemented
proc is_linetouched *(PWindow,cint): bool {.discardable, nodecl, importc:"is_linetouched".}# implemented
proc is_wcintouched *(PWindow): bool {.discardable, nodecl, importc:"is_wcintouched".}# implemented
proc keyname *(cint): cstring {.discardable, nodecl, importc:"keyname".}# implemented
proc keypad *(PWindow,bool): cint {.discardable, nodecl, importc:"keypad".}# implemented
proc killchar *(): char {.discardable, nodecl, importc:"killchar".}# implemented
proc leaveok *(PWindow,bool): cint {.discardable, nodecl, importc:"leaveok".}# implemented
proc longname *(): cstring {.discardable, nodecl, importc:"longname".}# implemented
proc meta *(PWindow,bool): cint {.discardable, nodecl, importc:"meta".}# implemented
proc move *(a, b: cint;): cint {.discardable, nodecl, importc:"move".}# generated
proc mvaddch *(a, b: cint; TChtype): cint {.discardable, nodecl, importc:"mvaddch".}# generated
proc mvaddchnstr *(a, b: cint; PChtype, cint): cint {.discardable, nodecl, importc:"mvaddchnstr".}# generated
proc mvaddchstr *(a, b: cint; PChtype): cint {.discardable, nodecl, importc:"mvaddchstr".}# generated
proc mvaddnstr *(a, b: cint; cstring, cint): cint {.discardable, nodecl, importc:"mvaddnstr".}# generated
proc mvaddstr *(a, b: cint; cstring): cint {.discardable, nodecl, importc:"mvaddstr".}# generated
proc mvchgat *(a, b: cint; cint, TAttr, cshort, PVoid): cint {.discardable, nodecl, importc:"mvchgat".}# generated
proc mvcur *(a, b, c, d: cint): cint {.discardable, nodecl, importc:"mvcur".}# implemented
proc mvdelch *(a, b: cint;): cint {.discardable, nodecl, importc:"mvdelch".}# generated
proc mvderwin *(PWindow, a, b: cint;): cint {.discardable, nodecl, importc:"mvderwin".}# implemented
proc mvgetch *(a, b: cint;): cint {.discardable, nodecl, importc:"mvgetch".}# generated
proc mvgetnstr *(a, b: cint; cstring, cint): cint {.discardable, nodecl, importc:"mvgetnstr".}# generated
proc mvgetstr *(a, b: cint; cstring): cint {.discardable, nodecl, importc:"mvgetstr".}# generated
proc mvhline *(a, b: cint; TChtype, cint): cint {.discardable, nodecl, importc:"mvhline".}# generated
proc mvinch *(a, b: cint;): TChtype {.discardable, nodecl, importc:"mvinch".}# generated
proc mvinchnstr *(a, b: cint; PChtype, cint): cint {.discardable, nodecl, importc:"mvinchnstr".}# generated
proc mvinchstr *(a, b: cint; PChtype): cint {.discardable, nodecl, importc:"mvinchstr".}# generated
proc mvinnstr *(a, b: cint; cstring, cint): cint {.discardable, nodecl, importc:"mvinnstr".}# generated
proc mvinsch *(a, b: cint; TChtype): cint {.discardable, nodecl, importc:"mvinsch".}# generated
proc mvinsnstr *(a, b: cint; cstring, cint): cint {.discardable, nodecl, importc:"mvinsnstr".}# generated
proc mvinsstr *(a, b: cint; cstring): cint {.discardable, nodecl, importc:"mvinsstr".}# generated
proc mvinstr *(a, b: cint; cstring): cint {.discardable, nodecl, importc:"mvinstr".}# generated

# TODO mvprcintw *(cint,cint, cstring,...): cint ;# implemented
# TODO mvscanw *(cint,cint, NCURSES_CONST cstring,...): cint ;# implemented

proc mvvline *(a, b: cint; TChtype, cint): cint {.discardable, nodecl, importc:"mvvline".}# generated
proc mvwaddch *(PWindow, a, b: cint; TChtype): cint {.discardable, nodecl, importc:"mvwaddch".}# generated
proc mvwaddchnstr *(PWindow, a, b: cint; PChtype, cint): cint {.discardable, nodecl, importc:"mvwaddchnstr".}# generated
proc mvwaddchstr *(PWindow, a, b: cint; PChtype): cint {.discardable, nodecl, importc:"mvwaddchstr".}# generated
proc mvwaddnstr *(PWindow, a, b: cint; cstring, cint): cint {.discardable, nodecl, importc:"mvwaddnstr".}# generated
proc mvwaddstr *(PWindow, a, b: cint; cstring): cint {.discardable, nodecl, importc:"mvwaddstr".}# generated
proc mvwchgat *(PWindow, a, b: cint; cint, TAttr, cshort, PVoid): cint {.discardable, nodecl, importc:"mvwchgat".}# generated
proc mvwdelch *(PWindow, a, b: cint;): cint {.discardable, nodecl, importc:"mvwdelch".}# generated
proc mvwgetch *(PWindow, a, b: cint;): cint {.discardable, nodecl, importc:"mvwgetch".}# generated
proc mvwgetnstr *(PWindow, a, b: cint; cstring, cint): cint {.discardable, nodecl, importc:"mvwgetnstr".}# generated
proc mvwgetstr *(PWindow, a, b: cint; cstring): cint {.discardable, nodecl, importc:"mvwgetstr".}# generated
proc mvwhline *(PWindow, a, b: cint; TChtype, cint): cint {.discardable, nodecl, importc:"mvwhline".}# generated
proc mvwin *(PWindow; a, b: cint): cint {.discardable, nodecl, importc:"mvwin".}# implemented
proc mvwinch *(PWindow, a, b: cint;): TChtype {.discardable, nodecl, importc:"mvwinch".}# generated
proc mvwinchnstr *(PWindow, a, b: cint; PChtype, cint): cint {.discardable, nodecl, importc:"mvwinchnstr".}# generated
proc mvwinchstr *(PWindow, a, b: cint; PChtype): cint {.discardable, nodecl, importc:"mvwinchstr".}# generated
proc mvwinnstr *(PWindow, a, b: cint; cstring, cint): cint {.discardable, nodecl, importc:"mvwinnstr".}# generated
proc mvwinsch *(PWindow, a, b: cint; TChtype): cint {.discardable, nodecl, importc:"mvwinsch".}# generated
proc mvwinsnstr *(PWindow, a, b: cint; cstring, cint): cint {.discardable, nodecl, importc:"mvwinsnstr".}# generated
proc mvwinsstr *(PWindow, a, b: cint; cstring): cint {.discardable, nodecl, importc:"mvwinsstr".}# generated
proc mvwinstr *(PWindow, a, b: cint; cstring): cint {.discardable, nodecl, importc:"mvwinstr".}# generated

# TODO mvwprcintw *(PWindow,cint,cint, cstring,...): cint ;# implemented
# TODO mvwscanw *(PWindow,cint,cint, NCURSES_CONST cstring,...): cint ;# implemented

proc mvwvline *(PWindow,a, b: cint; TChtype, cint): cint {.discardable, nodecl, importc:"mvwvline".}# generated
proc napms *(cint): cint {.discardable, nodecl, importc:"napms".}# implemented
proc newpad *(a, b: cint): PWindow {.discardable, nodecl, importc:"newpad".}# implemented

# TODO newterm *(NCURSES_CONST cstring,FILE *,FILE *): PScreen ;# implemented

proc newwin *(a, b, c, d: cint): PWindow {.discardable, nodecl, importc:"newwin".}# implemented
proc nl *(): cint {.discardable, nodecl, importc:"nl".}# implemented
proc nocbreak *(): cint {.discardable, nodecl, importc:"nocbreak".}# implemented
proc nodelay *(PWindow,bool): cint {.discardable, nodecl, importc:"nodelay".}# implemented
proc noecho *(): cint {.discardable, nodecl, importc:"noecho".}# implemented
proc nonl *(): cint {.discardable, nodecl, importc:"nonl".}# implemented
proc noqiflush *() {.discardable, nodecl, importc:"noqiflush".}# implemented
proc noraw *(): cint {.discardable, nodecl, importc:"noraw".}# implemented
proc notimeout *(PWindow,bool): cint {.discardable, nodecl, importc:"notimeout".}# implemented
proc overlay *(a, b: PWindow): cint {.discardable, nodecl, importc:"overlay".}# implemented
proc overwrite *(a, b: PWindow): cint {.discardable, nodecl, importc:"overwrite".}# implemented
proc pair_content *(cshort; a , b: ptr cshort): cint {.discardable, nodecl, importc:"pair_content".}# implemented
proc PAIR_NUMBER *(cint): cint {.discardable, nodecl, importc:"PAIR_NUMBER".}# generated
proc pechochar *(PWindow, TChtype): cint {.discardable, nodecl, importc:"pechochar".}# implemented
proc pnoutrefresh *(PWindow; a, b, c, d, e, f: cint): cint {.discardable, nodecl, importc:"pnoutrefresh".}# implemented
proc prefresh *(PWindow; a, b, c, d, e, f: cint): cint {.discardable, nodecl, importc:"prefresh".}# implemented

# TODO prcintw *(cstring,...): cint ;# implemented

# TODO putwin *(PWindow, FILE *): cint ;# implemented

proc qiflush *() {.discardable, nodecl, importc:"qiflush".}# implemented
proc raw *(): cint {.discardable, nodecl, importc:"raw".}# implemented
proc redrawwin *(PWindow): cint {.discardable, nodecl, importc:"redrawwin".}# generated
proc refresh *(): cint {.discardable, nodecl, importc:"refresh".}# generated
proc resetty *(): cint {.discardable, nodecl, importc:"resetty".}# implemented
proc reset_prog_mode *(): cint {.discardable, nodecl, importc:"reset_prog_mode".}# implemented
proc reset_shell_mode *(): cint {.discardable, nodecl, importc:"reset_shell_mode".}# implemented

# TODO ripoffline *(cint, cint (*)(PWindow, cint)): cint ;# implemented

proc savetty *(): cint {.discardable, nodecl, importc:"savetty".}# implemented

# TODO scanw *(NCURSES_CONST cstring,...): cint ;# implemented

proc scr_dump *(cstring): cint {.discardable, nodecl, importc:"scr_dump".}# implemented
proc scr_init *(cstring): cint {.discardable, nodecl, importc:"scr_init".}# implemented
proc scrl *(cint): cint {.discardable, nodecl, importc:"scrl".}# generated
proc scroll *(PWindow): cint {.discardable, nodecl, importc:"scroll".}# generated
proc scrollok *(PWindow,bool): cint {.discardable, nodecl, importc:"scrollok".}# implemented
proc scr_restore *(cstring): cint {.discardable, nodecl, importc:"scr_restore".}# implemented
proc scr_set *(cstring): cint {.discardable, nodecl, importc:"scr_set".}# implemented
proc setscrreg *(a, b: cint;): cint {.discardable, nodecl, importc:"setscrreg".}# generated
proc set_term *(PScreen): PScreen {.discardable, nodecl, importc:"set_term".}# implemented
proc slk_attroff *(TChtype): cint {.discardable, nodecl, importc:"slk_attroff".}# implemented
proc slk_attr_off *(TAttr, PVoid): cint {.discardable, nodecl, importc:"slk_attr_off".}# generated:WIDEC
proc slk_attron *(TChtype): cint {.discardable, nodecl, importc:"slk_attron".}# implemented
proc slk_attr_on *(TAttr,PVoid): cint {.discardable, nodecl, importc:"slk_attr_on".}# generated:WIDEC
proc slk_attrset *(TChtype): cint {.discardable, nodecl, importc:"slk_attrset".}# implemented
proc slk_attr *(): TAttr {.discardable, nodecl, importc:"slk_attr".}# implemented
proc slk_attr_set *(TAttr,cshort,PVoid): cint {.discardable, nodecl, importc:"slk_attr_set".}# implemented
proc slk_clear *(): cint {.discardable, nodecl, importc:"slk_clear".}# implemented
proc slk_color *(cshort): cint {.discardable, nodecl, importc:"slk_color".}# implemented
proc slk_init *(cint): cint {.discardable, nodecl, importc:"slk_init".}# implemented
proc slk_label *(cint): cstring {.discardable, nodecl, importc:"slk_label".}# implemented
proc slk_noutrefresh *(): cint {.discardable, nodecl, importc:"slk_noutrefresh".}# implemented
proc slk_refresh *(): cint {.discardable, nodecl, importc:"slk_refresh".}# implemented
proc slk_restore *(): cint {.discardable, nodecl, importc:"slk_restore".}# implemented
proc slk_set *(a: cint; b: cstring; c: cint): cint {.discardable, nodecl, importc:"slk_set".}# implemented
proc slk_touch *(): cint {.discardable, nodecl, importc:"slk_touch".}# implemented
proc standout *(): cint {.discardable, nodecl, importc:"standout".}# generated
proc standend *(): cint {.discardable, nodecl, importc:"standend".}# generated
proc start_color *(): cint {.discardable, nodecl, importc:"start_color".}# implemented
proc subpad *(PWindow; a, b, c, d: cint): PWindow {.discardable, nodecl, importc:"subpad".}# implemented
proc subwin *(PWindow; a, b, c, d: cint): PWindow {.discardable, nodecl, importc:"subwin".}# implemented
proc syncok *(PWindow, bool): cint {.discardable, nodecl, importc:"syncok".}# implemented
proc termattrs *(): TChtype {.discardable, nodecl, importc:"termattrs".}# implemented
proc termname *(): cstring {.discardable, nodecl, importc:"termname".}# implemented
proc timeout *(cint) {.discardable, nodecl, importc:"timeout".}# generated
proc touchline *(PWindow, a, b: cint;): cint {.discardable, nodecl, importc:"touchline".}# generated
proc touchwin *(PWindow): cint {.discardable, nodecl, importc:"touchwin".}# generated
proc typeahead *(cint): cint {.discardable, nodecl, importc:"typeahead".}# implemented
proc ungetch *(cint): cint {.discardable, nodecl, importc:"ungetch".}# implemented
proc untouchwin *(PWindow): cint {.discardable, nodecl, importc:"untouchwin".}# generated
proc use_env *(bool) {.discardable, nodecl, importc:"use_env".}# implemented
proc vidattr *(TChtype): cint {.discardable, nodecl, importc:"vidattr".}# implemented
proc vidputs *(TChtype, NCURSES_OUTC): cint {.discardable, nodecl, importc:"vidputs".}# implemented
proc vline *(TChtype, cint): cint {.discardable, nodecl, importc:"vline".}# generated

# TODO vwprcintw *(PWindow, cstring,va_list): cint ;# implemented
# TODO vw_prcintw *(PWindow, cstring,va_list): cint ;# generated
# TODO vwscanw *(PWindow, NCURSES_CONST cstring,va_list): cint ;# implemented
# TODO vw_scanw *(PWindow, NCURSES_CONST cstring,va_list): cint ;# generated

proc waddch *(PWindow, TChtype): cint {.discardable, nodecl, importc:"waddch".}# implemented
proc waddchnstr *(PWindow,PChtype,cint): cint {.discardable, nodecl, importc:"waddchnstr".}# implemented
proc waddchstr *(PWindow,PChtype): cint {.discardable, nodecl, importc:"waddchstr".}# generated
proc waddnstr *(PWindow,cstring,cint): cint {.discardable, nodecl, importc:"waddnstr".}# implemented
proc waddstr *(PWindow,cstring): cint {.discardable, nodecl, importc:"waddstr".}# generated
proc wattron *(PWindow, cint): cint {.discardable, nodecl, importc:"wattron".}# generated
proc wattroff *(PWindow, cint): cint {.discardable, nodecl, importc:"wattroff".}# generated
proc wattrset *(PWindow, cint): cint {.discardable, nodecl, importc:"wattrset".}# generated
proc wattr_get *(a: PWindow, b: PAttr, c: ptr cshort, d: ptr void): cint {.discardable, nodecl, importc:"wattr_get".}# generated
proc wattr_on *(PWindow, TAttr, PVoid): cint {.discardable, nodecl, importc:"wattr_on".}# implemented
proc wattr_off *(PWindow, TAttr, PVoid): cint {.discardable, nodecl, importc:"wattr_off".}# implemented
proc wattr_set *(PWindow, TAttr, cshort, PVoid): cint {.discardable, nodecl, importc:"wattr_set".}# generated
proc wbkgd *(PWindow, TChtype): cint {.discardable, nodecl, importc:"wbkgd".}# implemented
proc wbkgdset *(PWindow,TChtype) {.discardable, nodecl, importc:"wbkgdset".}# implemented
proc wborder *(PWindow; a, b, c, d, e, f, g, h: TChtype): cint {.discardable, nodecl, importc:"wborder".}# implemented
proc wchgat *(PWindow, cint, TAttr, cshort, PVoid): cint {.discardable, nodecl, importc:"wchgat".}# implemented
proc wclear *(PWindow): cint {.discardable, nodecl, importc:"wclear".}# implemented
proc wclrtobot *(PWindow): cint {.discardable, nodecl, importc:"wclrtobot".}# implemented
proc wclrtoeol *(PWindow): cint {.discardable, nodecl, importc:"wclrtoeol".}# implemented
proc wcolor_set *(PWindow,cshort,PVoid): cint {.discardable, nodecl, importc:"wcolor_set".}# implemented
proc wcursyncup *(PWindow) {.discardable, nodecl, importc:"wcursyncup".}# implemented
proc wdelch *(PWindow): cint {.discardable, nodecl, importc:"wdelch".}# implemented
proc wdeleteln *(PWindow): cint {.discardable, nodecl, importc:"wdeleteln".}# generated
proc wechochar *(PWindow, TChtype): cint {.discardable, nodecl, importc:"wechochar".}# implemented
proc werase *(PWindow): cint {.discardable, nodecl, importc:"werase".}# implemented
proc wgetch *(PWindow): cint {.discardable, nodecl, importc:"wgetch".}# implemented
proc wgetnstr *(PWindow,cstring,cint): cint {.discardable, nodecl, importc:"wgetnstr".}# implemented
proc wgetstr *(PWindow, cstring): cint {.discardable, nodecl, importc:"wgetstr".}# generated
proc whline *(PWindow, TChtype, cint): cint {.discardable, nodecl, importc:"whline".}# implemented
proc winch *(PWindow): TChtype {.discardable, nodecl, importc:"winch".}# implemented
proc winchnstr *(PWindow, PChtype, cint): cint {.discardable, nodecl, importc:"winchnstr".}# implemented
proc winchstr *(PWindow, PChtype): cint {.discardable, nodecl, importc:"winchstr".}# generated
proc winnstr *(PWindow, cstring, cint): cint {.discardable, nodecl, importc:"winnstr".}# implemented
proc winsch *(PWindow, TChtype): cint {.discardable, nodecl, importc:"winsch".}# implemented
proc winsdelln *(PWindow,cint): cint {.discardable, nodecl, importc:"winsdelln".}# implemented
proc winsertln *(PWindow): cint {.discardable, nodecl, importc:"winsertln".}# generated
proc winsnstr *(PWindow, cstring,cint): cint {.discardable, nodecl, importc:"winsnstr".}# implemented
proc winsstr *(PWindow, cstring): cint {.discardable, nodecl, importc:"winsstr".}# generated
proc winstr *(PWindow, cstring): cint {.discardable, nodecl, importc:"winstr".}# generated
proc wmove *(PWindow,a, b: cint;): cint {.discardable, nodecl, importc:"wmove".}# implemented
proc wnoutrefresh *(PWindow): cint {.discardable, nodecl, importc:"wnoutrefresh".}# implemented

# TODO extern NCURSES_EXPORT*(cint) wprcintw (PWindow, cstring,...)# implemented

proc wredrawln *(PWindow; a, b: cint): cint {.discardable, nodecl, importc:"wredrawln".}# implemented
proc wrefresh *(PWindow): cint {.discardable, nodecl, importc:"wrefresh".}# implemented

# TODO extern NCURSES_EXPORT*(cint) wscanw (PWindow, NCURSES_CONST cstring,...)# implemented

proc wscrl *(PWindow,cint): cint {.discardable, nodecl, importc:"wscrl".}# implemented
proc wsetscrreg *(PWindow; a, b: cint): cint {.discardable, nodecl, importc:"wsetscrreg".}# implemented
proc wstandout *(PWindow): cint {.discardable, nodecl, importc:"wstandout".}# generated
proc wstandend *(PWindow): cint {.discardable, nodecl, importc:"wstandend".}# generated
proc wsyncdown *(PWindow) {.discardable, nodecl, importc:"wsyncdown".}# implemented
proc wsyncup *(PWindow) {.discardable, nodecl, importc:"wsyncup".}# implemented
proc wtimeout *(PWindow; cint) {.discardable, nodecl, importc:"wtimeout".}# implemented
proc wtouchln *(PWindow; a, b, c: cint): cint {.discardable, nodecl, importc:"wtouchln".}# implemented
proc wvline *(PWindow,TChtype,cint): cint {.discardable, nodecl, importc:"wvline".}# implemented

# }}}

# These are also declared in <term.h>:
proc tigetflag (cstring): int {.discardable, nodecl, importc: "tigetflag".}   # implemented
proc tigetnum (cstring): int {.discardable, nodecl, importc: "tigetnum".}     # implemented
proc tigetstr (cstring): cstring {.discardable, nodecl, importc: "tigetstr".} # implemented
proc putp (cstring): int {.discardable, nodecl, importc: "putp".}             # implemented

#if NCURSES_TPARM_VARARGS
# TODO extern NCURSES_EXPORT(char *) tparm (NCURSES_CONST char *, ...);	/* special */
#else
#extern NCURSES_EXPORT(char *) tparm (NCURSES_CONST char *, long,long,long,long,long,long,long,long,long);	/* special */
#extern NCURSES_EXPORT(char *) tparm_varargs (NCURSES_CONST char *, ...);	/* special */
#endif

# TODO extern NCURSES_EXPORT(char *) tiparm (const char *, ...);		/* special */

#/*
# * These functions are not in X/Open, but we use them in macro definitions:
# */
#extern NCURSES_EXPORT(int) getattrs (const WINDOW *);			/* generated */
#extern NCURSES_EXPORT(int) getcurx (const WINDOW *);			/* generated */
#extern NCURSES_EXPORT(int) getcury (const WINDOW *);			/* generated */
#extern NCURSES_EXPORT(int) getbegx (const WINDOW *);			/* generated */
#extern NCURSES_EXPORT(int) getbegy (const WINDOW *);			/* generated */
#extern NCURSES_EXPORT(int) getmaxx (const WINDOW *);			/* generated */
#extern NCURSES_EXPORT(int) getmaxy (const WINDOW *);			/* generated */
#extern NCURSES_EXPORT(int) getparx (const WINDOW *);			/* generated */
#extern NCURSES_EXPORT(int) getpary (const WINDOW *);			/* generated */
#
#/*
# * vid_attr() was implemented originally based on a draft of X/Open curses.
# */
##ifndef NCURSES_WIDECHAR
##define vid_attr(a,pair,opts) vidattr(a)
##endif

# These functions are extensions - not in X/Open Curses.
const
  ExtFuncs* = 20110404

# TODO typedef int (*NCURSES_WINDOW_CB)(WINDOW *, void *);
# TODO typedef int (*NCURSES_SCREEN_CB)(SCREEN *, void *);

proc is_term_resized *(a, b: int): bool {.discardable, nodecl, importc:"is_term_resized".}
proc keybound *(a, b: int): cstring {.discardable, nodecl, importc:"keybound".}
proc curses_version : cstring{.discardable, nodecl, importc:"curses_version".}
proc assume_default_colors *(a, b: int): int {.discardable, nodecl, importc:"assume_default_colors".}
proc define_key *(cstring, int): int {.discardable, nodecl, importc:"define_key".}
proc get_escdelay : int {.discardable, nodecl, importc:"get_escdelay".}
proc key_defined *(cstring): int {.discardable, nodecl, importc:"key_defined".}
proc keyok *(int, bool): int {.discardable, nodecl, importc:"keyok".}
proc resize_term *(a, b: int): int {.discardable, nodecl, importc:"resize_term".}
# NB: both of these are the same symbol to nimrod
# proc resizeterm *(a, b: int): int {.nodecl, importc:"resizeterm".}
proc set_escdelay *(int): int {.discardable, nodecl, importc:"set_escdelay".}
proc set_tabsize *(int): int {.discardable, nodecl, importc:"set_tabsize".}
proc use_default_colors : int {.discardable, nodecl, importc:"use_default_colors".}
proc use_extended_names *(bool): int {.discardable, nodecl, importc:"use_extended_names".}
proc use_legacy_coding *(int): int {.discardable, nodecl, importc:"use_legacy_coding".}

# TODO extern NCURSES_EXPORT(int) use_screen (SCREEN *, NCURSES_SCREEN_CB, void *);
# TODO extern NCURSES_EXPORT(int) use_window (WINDOW *, NCURSES_WINDOW_CB, void *);

proc wresize*(PWindow; a, b: int): int {.discardable, nodecl, importc: "wresize".}
proc nofilter*() {.discardable, nodecl, importc: "nofilter".}

# These extensions provide access to information stored in the WINDOW even
# when NCURSES_OPAQUE is set:

proc wgetparent *(PWindow): PWindow {.discardable, nodecl, importc: "wgetparent ".}                 # generated
proc is_cleared *(PWindow): bool {.discardable, nodecl, importc: "is_cleared ".}                    # generated
proc is_idcok *(PWindow): bool {.discardable, nodecl, importc: "is_idcok ".}                        # generated
proc is_idlok *(PWindow): bool {.discardable, nodecl, importc: "is_idlok ".}                        # generated
proc is_immedok *(PWindow): bool {.discardable, nodecl, importc: "is_immedok ".}                    # generated
proc is_keypad *(PWindow): bool {.discardable, nodecl, importc: "is_keypad ".}                      # generated
proc is_leaveok *(PWindow): bool {.discardable, nodecl, importc: "is_leaveok ".}                    # generated
proc is_nodelay *(PWindow): bool {.discardable, nodecl, importc: "is_nodelay ".}                    # generated
proc is_notimeout *(PWindow): bool {.discardable, nodecl, importc: "is_notimeout ".}                # generated
proc is_pad *(PWindow): bool {.discardable, nodecl, importc: "is_pad ".}                            # generated
proc is_scrollok *(PWindow): bool {.discardable, nodecl, importc: "is_scrollok ".}                  # generated
proc is_subwin *(PWindow): bool {.discardable, nodecl, importc: "is_subwin ".}                      # generated
proc is_syncok *(PWindow): bool {.discardable, nodecl, importc: "is_syncok ".}                      # generated
proc wgetscrreg *(PWindow; a, b: ptr cint): int {.discardable, nodecl, importc: "wgetscrreg ".} # generated

#else
template CursesVersion*() = Version
#endif

# unused {{{
#/*
# * Extra extension-functions, which pass a SCREEN pointer rather than using
# * a global variable SP.
# */
##if 0
##undef  NCURSES_SP_FUNCS
##define NCURSES_SP_FUNCS 20110404
##define NCURSES_SP_NAME(name) name##_sp
#
#/* Define the sp-funcs helper function */
##define NCURSES_SP_OUTC NCURSES_SP_NAME(NCURSES_OUTC)
#typedef int (*NCURSES_SP_OUTC)(SCREEN*, int);
#
#extern NCURSES_EXPORT(SCREEN *) new_prescr (void); /* implemented:SP_FUNC */
#
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(baudrate) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(beep) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(bool) NCURSES_SP_NAME(can_change_color) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(cbreak) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(curs_set) (SCREEN*, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(color_content) (SCREEN*, short, short*, short*, short*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(def_prog_mode) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(def_shell_mode) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(delay_output) (SCREEN*, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(doupdate) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(echo) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(endwin) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(char) NCURSES_SP_NAME(erasechar) (SCREEN*);/* implemented:SP_FUNC */
#extern NCURSES_EXPORT(void) NCURSES_SP_NAME(filter) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(flash) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(flushinp) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(WINDOW *) NCURSES_SP_NAME(getwin) (SCREEN*, FILE *);			/* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(halfdelay) (SCREEN*, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(bool) NCURSES_SP_NAME(has_colors) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(bool) NCURSES_SP_NAME(has_ic) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(bool) NCURSES_SP_NAME(has_il) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(init_color) (SCREEN*, short, short, short, short); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(init_pair) (SCREEN*, short, short, short); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(intrflush) (SCREEN*, WINDOW*, bool);	/* implemented:SP_FUNC */
#extern NCURSES_EXPORT(bool) NCURSES_SP_NAME(isendwin) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(NCURSES_CONST char *) NCURSES_SP_NAME(keyname) (SCREEN*, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(char) NCURSES_SP_NAME(killchar) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(char *) NCURSES_SP_NAME(longname) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(mvcur) (SCREEN*, int, int, int, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(napms) (SCREEN*, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(WINDOW *) NCURSES_SP_NAME(newpad) (SCREEN*, int, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(SCREEN *) NCURSES_SP_NAME(newterm) (SCREEN*, NCURSES_CONST char *, FILE *, FILE *); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(WINDOW *) NCURSES_SP_NAME(newwin) (SCREEN*, int, int, int, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(nl) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(nocbreak) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(noecho) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(nonl) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(void) NCURSES_SP_NAME(noqiflush) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(noraw) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(pair_content) (SCREEN*, short, short*, short*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(void) NCURSES_SP_NAME(qiflush) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(raw) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(reset_prog_mode) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(reset_shell_mode) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(resetty) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(ripoffline) (SCREEN*, int, int (*)(WINDOW *, int));	/* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(savetty) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(scr_init) (SCREEN*, const char *); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(scr_restore) (SCREEN*, const char *); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(scr_set) (SCREEN*, const char *); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(slk_attroff) (SCREEN*, const chtype); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(slk_attron) (SCREEN*, const chtype); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(slk_attrset) (SCREEN*, const chtype); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(attr_t) NCURSES_SP_NAME(slk_attr) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(slk_attr_set) (SCREEN*, const attr_t, short, void*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(slk_clear) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(slk_color) (SCREEN*, short); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(slk_init) (SCREEN*, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(char *) NCURSES_SP_NAME(slk_label) (SCREEN*, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(slk_noutrefresh) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(slk_refresh) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(slk_restore) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(slk_set) (SCREEN*, int, const char *, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(slk_touch) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(start_color) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(chtype) NCURSES_SP_NAME(termattrs) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(char *) NCURSES_SP_NAME(termname) (SCREEN*); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(typeahead) (SCREEN*, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(ungetch) (SCREEN*, int); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(void) NCURSES_SP_NAME(use_env) (SCREEN*, bool); /* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(vidattr) (SCREEN*, chtype);	/* implemented:SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(vidputs) (SCREEN*, chtype, NCURSES_SP_OUTC); /* implemented:SP_FUNC */
##if 1
#extern NCURSES_EXPORT(char *) NCURSES_SP_NAME(keybound) (SCREEN*, int, int);	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(assume_default_colors) (SCREEN*, int, int);	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(define_key) (SCREEN*, const char *, int);	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(get_escdelay) (SCREEN*);	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(bool) NCURSES_SP_NAME(is_term_resized) (SCREEN*, int, int);	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(key_defined) (SCREEN*, const char *);	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(keyok) (SCREEN*, int, bool);	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(void) NCURSES_SP_NAME(nofilter) (SCREEN*); /* implemented */	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(resize_term) (SCREEN*, int, int);	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(resizeterm) (SCREEN*, int, int);	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(set_escdelay) (SCREEN*, int);	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(set_tabsize) (SCREEN*, int);	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(use_default_colors) (SCREEN*);	/* implemented:EXT_SP_FUNC */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(use_legacy_coding) (SCREEN*, int);	/* implemented:EXT_SP_FUNC */
##endif
##else
##undef  NCURSES_SP_FUNCS
##define NCURSES_SP_FUNCS 0
##define NCURSES_SP_NAME(name) name
##define NCURSES_SP_OUTC NCURSES_OUTC
##endif
# }}}

# attributes

const
  AttrShift = 8

proc Bits(mask, shift: int): int {.discardable, noSideEffect, compileTime.} =
  ((mask) shl (shift + AttrShift))

const
  A_NORMAL     * = (1 - 1)
  A_ATTRIBUTES * = BITS((not 1) - 1,0)
  A_CHARTEXT   * = (BITS(1,0) - 1)
  A_COLOR      * = BITS(((1) shl 8) - 1,0)
  A_STANDOUT   * = BITS(1,8)
  A_UNDERLINE  * = BITS(1,9)
  A_REVERSE    * = BITS(1,10)
  A_BLINK      * = BITS(1,11)
  A_DIM        * = BITS(1,12)
  A_BOLD       * = BITS(1,13)
  A_ALTCHARSET * = BITS(1,14)
  A_INVIS      * = BITS(1,15)
  A_PROTECT    * = BITS(1,16)
  A_HORIZONTAL * = BITS(1,17)
  A_LEFT       * = BITS(1,18)
  A_LOW        * = BITS(1,19)
  A_RIGHT      * = BITS(1,20)
  A_TOP        * = BITS(1,21)
  A_VERTICAL   * = BITS(1,22)

# Most of the pseudo functions are macros that either provide compatibility
# with older versions of curses, or provide inline functionality to improve
# performance.

# These pseudo functions are always implemented as macros:

# TODO {{{

##define getyx(win,y,x)   	(y = getcury(win), x = getcurx(win))
##define getbegyx(win,y,x)	(y = getbegy(win), x = getbegx(win))
##define getmaxyx(win,y,x)	(y = getmaxy(win), x = getmaxx(win))
##define getparyx(win,y,x)	(y = getpary(win), x = getparx(win))
#
##define getsyx(y,x) do { if (newscr) { \
#			     if (is_leaveok(newscr)) \
#				(y) = (x) = -1; \
#			     else \
#				 getyx(newscr,(y), (x)); \
#			} \
#		    } while(0)
#
##define setsyx(y,x) do { if (newscr) { \
#			    if ((y) == -1 && (x) == -1) \
#				leaveok(newscr, TRUE); \
#			    else { \
#				leaveok(newscr, FALSE); \
#				wmove(newscr, (y), (x)); \
#			    } \
#			} \
#		    } while(0)
#
##ifndef NCURSES_NOMACROS
#
#/*
# * These miscellaneous pseudo functions are provided for compatibility:
# */
#
##define wgetstr(w, s)		wgetnstr(w, s, -1)
##define getnstr(s, n)		wgetnstr(stdscr, s, n)
#
##define setterm(term)		setupterm(term, 1, (int *)0)
#
##define fixterm()		reset_prog_mode()
##define resetterm()		reset_shell_mode()
##define saveterm()		def_prog_mode()
##define crmode()		cbreak()
##define nocrmode()		nocbreak()
##define gettmode()
#
#/* It seems older SYSV curses versions define these */
##if !NCURSES_OPAQUE
##define getattrs(win)		NCURSES_CAST(int, (win) ? (win)->_attrs : A_NORMAL)
##define getcurx(win)		((win) ? (win)->_curx : ERR)
##define getcury(win)		((win) ? (win)->_cury : ERR)
##define getbegx(win)		((win) ? (win)->_begx : ERR)
##define getbegy(win)		((win) ? (win)->_begy : ERR)
##define getmaxx(win)		((win) ? ((win)->_maxx + 1) : ERR)
##define getmaxy(win)		((win) ? ((win)->_maxy + 1) : ERR)
##define getparx(win)		((win) ? (win)->_parx : ERR)
##define getpary(win)		((win) ? (win)->_pary : ERR)
##endif /* NCURSES_OPAQUE */
#
##define wstandout(win)      	(wattrset(win,A_STANDOUT))
##define wstandend(win)      	(wattrset(win,A_NORMAL))
#
##define wattron(win,at)		wattr_on(win, NCURSES_CAST(attr_t, at), NULL)
##define wattroff(win,at)	wattr_off(win, NCURSES_CAST(attr_t, at), NULL)
#
##if !NCURSES_OPAQUE
##if defined(NCURSES_WIDECHAR) && 0
##define wattrset(win,at)	((win) \
#				  ? ((win)->_color = PAIR_NUMBER(at), \
#                                     (win)->_attrs = NCURSES_CAST(attr_t, at), \
#                                     OK) \
#				  : ERR)
##else
##define wattrset(win,at)        ((win) \
#				  ? ((win)->_attrs = NCURSES_CAST(attr_t, at), \
#				     OK) \
#				  : ERR)
##endif
##endif /* NCURSES_OPAQUE */
#
##define scroll(win)		wscrl(win,1)
#
##define touchwin(win)		wtouchln((win), 0, getmaxy(win), 1)
##define touchline(win, s, c)	wtouchln((win), s, c, 1)
##define untouchwin(win)		wtouchln((win), 0, getmaxy(win), 0)
#
##define box(win, v, h)		wborder(win, v, v, h, h, 0, 0, 0, 0)
##define border(ls, rs, ts, bs, tl, tr, bl, br)	wborder(stdscr, ls, rs, ts, bs, tl, tr, bl, br)
##define hline(ch, n)		whline(stdscr, ch, n)
##define vline(ch, n)		wvline(stdscr, ch, n)
#
##define winstr(w, s)		winnstr(w, s, -1)
##define winchstr(w, s)		winchnstr(w, s, -1)
##define winsstr(w, s)		winsnstr(w, s, -1)
#
##if !NCURSES_OPAQUE
##define redrawwin(win)		wredrawln(win, 0, (win)->_maxy+1)
##endif /* NCURSES_OPAQUE */
#
##define waddstr(win,str)	waddnstr(win,str,-1)
##define waddchstr(win,str)	waddchnstr(win,str,-1)

# }}}

# TODO probably need these {{{
# These apply to the first 256 color pairs.
#define COLOR_PAIR(n)	NCURSES_BITS(n, 0)
#define PAIR_NUMBER(a)	(NCURSES_CAST(int,((NCURSES_CAST(unsigned long,a) & A_COLOR) >> NCURSES_ATTR_SHIFT)))
# }}}

# NB: Probably not going to bind these without a good reason {{{

## pseudo functions for standard screen
#
##define addch(ch)		waddch(stdscr,ch)
##define addchnstr(str,n)	waddchnstr(stdscr,str,n)
##define addchstr(str)		waddchstr(stdscr,str)
##define addnstr(str,n)		waddnstr(stdscr,str,n)
##define addstr(str)		waddnstr(stdscr,str,-1)
##define attroff(at)		wattroff(stdscr,at)
##define attron(at)		wattron(stdscr,at)
##define attrset(at)		wattrset(stdscr,at)
##define attr_get(ap,cp,o)	wattr_get(stdscr,ap,cp,o)
##define attr_off(a,o)		wattr_off(stdscr,a,o)
##define attr_on(a,o)		wattr_on(stdscr,a,o)
##define attr_set(a,c,o)		wattr_set(stdscr,a,c,o)
##define bkgd(ch)		wbkgd(stdscr,ch)
##define bkgdset(ch)		wbkgdset(stdscr,ch)
##define chgat(n,a,c,o)		wchgat(stdscr,n,a,c,o)
##define clear()			wclear(stdscr)
##define clrtobot()		wclrtobot(stdscr)
##define clrtoeol()		wclrtoeol(stdscr)
##define color_set(c,o)		wcolor_set(stdscr,c,o)
##define delch()			wdelch(stdscr)
##define deleteln()		winsdelln(stdscr,-1)
##define echochar(c)		wechochar(stdscr,c)
##define erase()			werase(stdscr)
##define getch()			wgetch(stdscr)
##define getstr(str)		wgetstr(stdscr,str)
##define inch()			winch(stdscr)
##define inchnstr(s,n)		winchnstr(stdscr,s,n)
##define inchstr(s)		winchstr(stdscr,s)
##define innstr(s,n)		winnstr(stdscr,s,n)
##define insch(c)		winsch(stdscr,c)
##define insdelln(n)		winsdelln(stdscr,n)
##define insertln()		winsdelln(stdscr,1)
##define insnstr(s,n)		winsnstr(stdscr,s,n)
##define insstr(s)		winsstr(stdscr,s)
##define instr(s)		winstr(stdscr,s)
##define move(y,x)		wmove(stdscr,y,x)
##define refresh()		wrefresh(stdscr)
##define scrl(n)			wscrl(stdscr,n)
##define setscrreg(t,b)		wsetscrreg(stdscr,t,b)
##define standend()		wstandend(stdscr)
##define standout()		wstandout(stdscr)
##define timeout(delay)		wtimeout(stdscr,delay)
##define wdeleteln(win)		winsdelln(win,-1)
##define winsertln(win)		winsdelln(win,1)
#
#/*
# * mv functions
# */
#
##define mvwaddch(win,y,x,ch)		(wmove(win,y,x) == ERR ? ERR : waddch(win,ch))
##define mvwaddchnstr(win,y,x,str,n)	(wmove(win,y,x) == ERR ? ERR : waddchnstr(win,str,n))
##define mvwaddchstr(win,y,x,str)	(wmove(win,y,x) == ERR ? ERR : waddchnstr(win,str,-1))
##define mvwaddnstr(win,y,x,str,n)	(wmove(win,y,x) == ERR ? ERR : waddnstr(win,str,n))
##define mvwaddstr(win,y,x,str)		(wmove(win,y,x) == ERR ? ERR : waddnstr(win,str,-1))
##define mvwdelch(win,y,x)		(wmove(win,y,x) == ERR ? ERR : wdelch(win))
##define mvwchgat(win,y,x,n,a,c,o)	(wmove(win,y,x) == ERR ? ERR : wchgat(win,n,a,c,o))
##define mvwgetch(win,y,x)		(wmove(win,y,x) == ERR ? ERR : wgetch(win))
##define mvwgetnstr(win,y,x,str,n)	(wmove(win,y,x) == ERR ? ERR : wgetnstr(win,str,n))
##define mvwgetstr(win,y,x,str)		(wmove(win,y,x) == ERR ? ERR : wgetstr(win,str))
##define mvwhline(win,y,x,c,n)		(wmove(win,y,x) == ERR ? ERR : whline(win,c,n))
##define mvwinch(win,y,x)		(wmove(win,y,x) == ERR ? NCURSES_CAST(chtype, ERR) : winch(win))
##define mvwinchnstr(win,y,x,s,n)	(wmove(win,y,x) == ERR ? ERR : winchnstr(win,s,n))
##define mvwinchstr(win,y,x,s)		(wmove(win,y,x) == ERR ? ERR : winchstr(win,s))
##define mvwinnstr(win,y,x,s,n)		(wmove(win,y,x) == ERR ? ERR : winnstr(win,s,n))
##define mvwinsch(win,y,x,c)		(wmove(win,y,x) == ERR ? ERR : winsch(win,c))
##define mvwinsnstr(win,y,x,s,n)		(wmove(win,y,x) == ERR ? ERR : winsnstr(win,s,n))
##define mvwinsstr(win,y,x,s)		(wmove(win,y,x) == ERR ? ERR : winsstr(win,s))
##define mvwinstr(win,y,x,s)		(wmove(win,y,x) == ERR ? ERR : winstr(win,s))
##define mvwvline(win,y,x,c,n)		(wmove(win,y,x) == ERR ? ERR : wvline(win,c,n))
#
##define mvaddch(y,x,ch)			mvwaddch(stdscr,y,x,ch)
##define mvaddchnstr(y,x,str,n)		mvwaddchnstr(stdscr,y,x,str,n)
##define mvaddchstr(y,x,str)		mvwaddchstr(stdscr,y,x,str)
##define mvaddnstr(y,x,str,n)		mvwaddnstr(stdscr,y,x,str,n)
##define mvaddstr(y,x,str)		mvwaddstr(stdscr,y,x,str)
##define mvchgat(y,x,n,a,c,o)		mvwchgat(stdscr,y,x,n,a,c,o)
##define mvdelch(y,x)			mvwdelch(stdscr,y,x)
##define mvgetch(y,x)			mvwgetch(stdscr,y,x)
##define mvgetnstr(y,x,str,n)		mvwgetnstr(stdscr,y,x,str,n)
##define mvgetstr(y,x,str)		mvwgetstr(stdscr,y,x,str)
##define mvhline(y,x,c,n)		mvwhline(stdscr,y,x,c,n)
##define mvinch(y,x)			mvwinch(stdscr,y,x)
##define mvinchnstr(y,x,s,n)		mvwinchnstr(stdscr,y,x,s,n)
##define mvinchstr(y,x,s)		mvwinchstr(stdscr,y,x,s)
##define mvinnstr(y,x,s,n)		mvwinnstr(stdscr,y,x,s,n)
##define mvinsch(y,x,c)			mvwinsch(stdscr,y,x,c)
##define mvinsnstr(y,x,s,n)		mvwinsnstr(stdscr,y,x,s,n)
##define mvinsstr(y,x,s)			mvwinsstr(stdscr,y,x,s)
##define mvinstr(y,x,s)			mvwinstr(stdscr,y,x,s)
##define mvvline(y,x,c,n)		mvwvline(stdscr,y,x,c,n)
#
#/*
# * Some wide-character functions can be implemented without the extensions.
# */
##if !NCURSES_OPAQUE
##define getbkgd(win)                    ((win)->_bkgd)
##endif /* NCURSES_OPAQUE */
#
##define slk_attr_off(a,v)		((v) ? ERR : slk_attroff(a))
##define slk_attr_on(a,v)		((v) ? ERR : slk_attron(a))
#
##if !NCURSES_OPAQUE
##if defined(NCURSES_WIDECHAR) && 0
##define wattr_set(win,a,p,opts)		((win)->_attrs = ((a) & ~A_COLOR), \
#					 (win)->_color = (p), \
#					 OK)
##define wattr_get(win,a,p,opts)		((void)((a) != (void *)0 && (*(a) = (win)->_attrs)), \
#					 (void)((p) != (void *)0 && (*(p) = (short)(win)->_color)), \
#					 OK)
##else
##define wattr_set(win,a,p,opts)		((win)->_attrs = (((a) & ~A_COLOR) | (attr_t)COLOR_PAIR(p)), OK)
##define wattr_get(win,a,p,opts)		((void)((a) != (void *)0 && (*(a) = (win)->_attrs)), \
#					 (void)((p) != (void *)0 && (*(p) = (short)PAIR_NUMBER((win)->_attrs))), \
#					 OK)
##endif
##endif /* NCURSES_OPAQUE */
#
#/*
# * X/Open curses deprecates SVr4 vwprintw/vwscanw, which are supposed to use
# * varargs.h.  It adds new calls vw_printw/vw_scanw, which are supposed to
# * use POSIX stdarg.h.  The ncurses versions of vwprintw/vwscanw already
# * use stdarg.h, so...
# */
##define vw_printw		vwprintw
##define vw_scanw		vwscanw
#
#/*
# * Export fallback function for use in C++ binding.
# */
##if !1
##define vsscanf(a,b,c) _nc_vsscanf(a,b,c)
#NCURSES_EXPORT(int) vsscanf(const char *, const char *, va_list);
##endif
#
#/*
# * These macros are extensions - not in X/Open Curses.
# */
##if 1
##if !NCURSES_OPAQUE
##define is_cleared(win)		((win) ? (win)->_clear : FALSE)
##define is_idcok(win)		((win) ? (win)->_idcok : FALSE)
##define is_idlok(win)		((win) ? (win)->_idlok : FALSE)
##define is_immedok(win)		((win) ? (win)->_immed : FALSE)
##define is_keypad(win)		((win) ? (win)->_use_keypad : FALSE)
##define is_leaveok(win)		((win) ? (win)->_leaveok : FALSE)
##define is_nodelay(win)		((win) ? ((win)->_delay == 0) : FALSE)
##define is_notimeout(win)	((win) ? (win)->_notimeout : FALSE)
##define is_pad(win)		((win) ? ((win)->_flags & _ISPAD) != 0 : FALSE)
##define is_scrollok(win)	((win) ? (win)->_scroll : FALSE)
##define is_subwin(win)		((win) ? ((win)->_flags & _SUBWIN) != 0 : FALSE)
##define is_syncok(win)		((win) ? (win)->_sync : FALSE)
##define wgetparent(win)		((win) ? (win)->_parent : 0)
##define wgetscrreg(win,t,b)	((win) ? (*(t) = (win)->_regtop, *(b) = (win)->_regbottom, OK) : ERR)
##endif
##endif
#
##endif /* NCURSES_NOMACROS */

# }}}

# Public variables.
#
# Notes:
#	a. ESCDELAY was an undocumented feature under AIX curses.
#	   It gives the ESC expire time in milliseconds.
#	b. ttytype is needed for backward compatibility

##if NCURSES_REENTRANT
#
#NCURSES_WRAPPED_VAR(WINDOW *, curscr);
#NCURSES_WRAPPED_VAR(WINDOW *, newscr);
#NCURSES_WRAPPED_VAR(WINDOW *, stdscr);
#NCURSES_WRAPPED_VAR(char *, ttytype);
#NCURSES_WRAPPED_VAR(int, COLORS);
#NCURSES_WRAPPED_VAR(int, COLOR_PAIRS);
#NCURSES_WRAPPED_VAR(int, COLS);
#NCURSES_WRAPPED_VAR(int, ESCDELAY);
#NCURSES_WRAPPED_VAR(int, LINES);
#NCURSES_WRAPPED_VAR(int, TABSIZE);
#
##define curscr      NCURSES_PUBLIC_VAR(curscr())
##define newscr      NCURSES_PUBLIC_VAR(newscr())
##define stdscr      NCURSES_PUBLIC_VAR(stdscr())
##define ttytype     NCURSES_PUBLIC_VAR(ttytype())
##define COLORS      NCURSES_PUBLIC_VAR(COLORS())
##define COLOR_PAIRS NCURSES_PUBLIC_VAR(COLOR_PAIRS())
##define COLS        NCURSES_PUBLIC_VAR(COLS())
##define ESCDELAY    NCURSES_PUBLIC_VAR(ESCDELAY())
##define LINES       NCURSES_PUBLIC_VAR(LINES())
##define TABSIZE     NCURSES_PUBLIC_VAR(TABSIZE())
#
##else

var curscr      * {.nodecl, importc: "curscr".} : PWindow
var newscr      * {.nodecl, importc: "newscr".} : PWindow
var stdscr      * {.nodecl, importc: "stdscr".} : PWindow
var ttytype     * {.nodecl, importc: "ttytype".} : array[0..10000,cstring]
var COLORS      * {.nodecl, importc: "COLORS".} : int
var COLOR_PAIRS * {.nodecl, importc: "COLOR_PAIRS".} : int
var COLS        * {.nodecl, importc: "COLS".} : int
var ESCDELAY    * {.nodecl, importc: "ESCDELAY".} : int
var LINES       * {.nodecl, importc: "LINES".} : int
var TABSIZE     * {.nodecl, importc: "TABSIZE".} : int

##endif

const
  # Pseudo-character tokens outside ASCII range.  The curses wgetch() function
  # will return any given one of these only if the corresponding k- capability
  # is defined in your terminal's terminfo entry.
  #
  # Some keys (KEY_A1, etc) are arranged like this:
  #	a1     up    a3
  #	left   b2    right
  #	c1     down  c3
  #
  # A few key codes do not depend upon the terminfo entry.

  KEY_CODE_YES = 0400 # A wchar_t contains a key code
  KEY_MIN      = 0401 # Minimum curses key
  KEY_BREAK    = 0401 # Break key (unreliable)
  KEY_SRESET   = 0530 # Soft (partial) reset (unreliable)
  KEY_RESET    = 0531 # Reset or hard reset (unreliable)

  # These definitions were generated by /build/buildd/ncurses-5.9/include/MKkey_defs.sh /build/buildd/ncurses-5.9/include/Caps

  KEY_DOWN      = 0402 # down-arrow key
  KEY_UP        = 0403 # up-arrow key
  KEY_LEFT      = 0404 # left-arrow key
  KEY_RIGHT     = 0405 # right-arrow key
  KEY_HOME      = 0406 # home key
  KEY_BACKSPACE = 0407 # backspace key

  KEY_F0 = 0410       # Function keys.  Space for 64

template KEY_F(n) = # Value of function key n
  (KEY_F0+(n))

const
  KEY_DL        = 0510 # delete-line key
  KEY_IL        = 0511 # insert-line key
  KEY_DC        = 0512 # delete-character key
  KEY_IC        = 0513 # insert-character key
  KEY_EIC       = 0514 # sent by rmir or smir in insert mode
  KEY_CLEAR     = 0515 # clear-screen or erase key
  KEY_EOS       = 0516 # clear-to-end-of-screen key
  KEY_EOL       = 0517 # clear-to-end-of-line key
  KEY_SF        = 0520 # scroll-forward key
  KEY_SR        = 0521 # scroll-backward key
  KEY_NPAGE     = 0522 # next-page key
  KEY_PPAGE     = 0523 # previous-page key
  KEY_STAB      = 0524 # set-tab key
  KEY_CTAB      = 0525 # clear-tab key
  KEY_CATAB     = 0526 # clear-all-tabs key
  KEY_ENTER     = 0527 # enter/send key
  KEY_PRINT     = 0532 # print key
  KEY_LL        = 0533 # lower-left key (home down)
  KEY_A1        = 0534 # upper left of keypad
  KEY_A3        = 0535 # upper right of keypad
  KEY_B2        = 0536 # center of keypad
  KEY_C1        = 0537 # lower left of keypad
  KEY_C3        = 0540 # lower right of keypad
  KEY_BTAB      = 0541 # back-tab key
  KEY_BEG       = 0542 # begin key
  KEY_CANCEL    = 0543 # cancel key
  KEY_CLOSE     = 0544 # close key
  KEY_COMMAND   = 0545 # command key
  KEY_COPY      = 0546 # copy key
  KEY_CREATE    = 0547 # create key
  KEY_END       = 0550 # end key
  KEY_EXIT      = 0551 # exit key
  KEY_FIND      = 0552 # find key
  KEY_HELP      = 0553 # help key
  KEY_MARK      = 0554 # mark key
  KEY_MESSAGE   = 0555 # message key
  KEY_MOVE      = 0556 # move key
  KEY_NEXT      = 0557 # next key
  KEY_OPEN      = 0560 # open key
  KEY_OPTIONS   = 0561 # options key
  KEY_PREVIOUS  = 0562 # previous key
  KEY_REDO      = 0563 # redo key
  KEY_REFERENCE = 0564 # reference key
  KEY_REFRESH   = 0565 # refresh key
  KEY_REPLACE   = 0566 # replace key
  KEY_RESTART   = 0567 # restart key
  KEY_RESUME    = 0570 # resume key
  KEY_SAVE      = 0571 # save key
  KEY_SBEG      = 0572 # shifted begin key
  KEY_SCANCEL   = 0573 # shifted cancel key
  KEY_SCOMMAND  = 0574 # shifted command key
  KEY_SCOPY     = 0575 # shifted copy key
  KEY_SCREATE   = 0576 # shifted create key
  KEY_SDC       = 0577 # shifted delete-character key
  KEY_SDL       = 0600 # shifted delete-line key
  KEY_SELECT    = 0601 # select key
  KEY_SEND      = 0602 # shifted end key
  KEY_SEOL      = 0603 # shifted clear-to-end-of-line key
  KEY_SEXIT     = 0604 # shifted exit key
  KEY_SFIND     = 0605 # shifted find key
  KEY_SHELP     = 0606 # shifted help key
  KEY_SHOME     = 0607 # shifted home key
  KEY_SIC       = 0610 # shifted insert-character key
  KEY_SLEFT     = 0611 # shifted left-arrow key
  KEY_SMESSAGE  = 0612 # shifted message key
  KEY_SMOVE     = 0613 # shifted move key
  KEY_SNEXT     = 0614 # shifted next key
  KEY_SOPTIONS  = 0615 # shifted options key
  KEY_SPREVIOUS = 0616 # shifted previous key
  KEY_SPRINT    = 0617 # shifted print key
  KEY_SREDO     = 0620 # shifted redo key
  KEY_SREPLACE  = 0621 # shifted replace key
  KEY_SRIGHT    = 0622 # shifted right-arrow key
  KEY_SRSUME    = 0623 # shifted resume key
  KEY_SSAVE     = 0624 # shifted save key
  KEY_SSUSPEND  = 0625 # shifted suspend key
  KEY_SUNDO     = 0626 # shifted undo key
  KEY_SUSPEND   = 0627 # suspend key
  KEY_UNDO      = 0630 # undo key
  KEY_MOUSE     = 0631 # Mouse event has occurred
  KEY_RESIZE    = 0632 # Terminal resize event
  KEY_EVENT     = 0633 # We were interrupted by an event
  KEY_MAX       = 0777 # Maximum key value is 0633

# $Id: curses.tail,v 1.20 2010/03/28 19:10:55 tom Exp $

# vile:cmode:
# This file is part of ncurses, designed to be appended after curses.h.in
# (see that file for the relevant copyright).

# mouse interface

# NB mouse stuff doesn't seem to work anyway {{{
#
##if NCURSES_MOUSE_VERSION > 1
##define NCURSES_MOUSE_MASK(b,m) ((m) << (((b) - 1) * 5))
##else
##define NCURSES_MOUSE_MASK(b,m) ((m) << (((b) - 1) * 6))
##endif
#
##define	NCURSES_BUTTON_RELEASED	001L
##define	NCURSES_BUTTON_PRESSED	002L
##define	NCURSES_BUTTON_CLICKED	004L
##define	NCURSES_DOUBLE_CLICKED	010L
##define	NCURSES_TRIPLE_CLICKED	020L
##define	NCURSES_RESERVED_EVENT	040L
#
#/* event masks */
##define	BUTTON1_RELEASED	NCURSES_MOUSE_MASK(1, NCURSES_BUTTON_RELEASED)
##define	BUTTON1_PRESSED		NCURSES_MOUSE_MASK(1, NCURSES_BUTTON_PRESSED)
##define	BUTTON1_CLICKED		NCURSES_MOUSE_MASK(1, NCURSES_BUTTON_CLICKED)
##define	BUTTON1_DOUBLE_CLICKED	NCURSES_MOUSE_MASK(1, NCURSES_DOUBLE_CLICKED)
##define	BUTTON1_TRIPLE_CLICKED	NCURSES_MOUSE_MASK(1, NCURSES_TRIPLE_CLICKED)
#
##define	BUTTON2_RELEASED	NCURSES_MOUSE_MASK(2, NCURSES_BUTTON_RELEASED)
##define	BUTTON2_PRESSED		NCURSES_MOUSE_MASK(2, NCURSES_BUTTON_PRESSED)
##define	BUTTON2_CLICKED		NCURSES_MOUSE_MASK(2, NCURSES_BUTTON_CLICKED)
##define	BUTTON2_DOUBLE_CLICKED	NCURSES_MOUSE_MASK(2, NCURSES_DOUBLE_CLICKED)
##define	BUTTON2_TRIPLE_CLICKED	NCURSES_MOUSE_MASK(2, NCURSES_TRIPLE_CLICKED)
#
##define	BUTTON3_RELEASED	NCURSES_MOUSE_MASK(3, NCURSES_BUTTON_RELEASED)
##define	BUTTON3_PRESSED		NCURSES_MOUSE_MASK(3, NCURSES_BUTTON_PRESSED)
##define	BUTTON3_CLICKED		NCURSES_MOUSE_MASK(3, NCURSES_BUTTON_CLICKED)
##define	BUTTON3_DOUBLE_CLICKED	NCURSES_MOUSE_MASK(3, NCURSES_DOUBLE_CLICKED)
##define	BUTTON3_TRIPLE_CLICKED	NCURSES_MOUSE_MASK(3, NCURSES_TRIPLE_CLICKED)
#
##define	BUTTON4_RELEASED	NCURSES_MOUSE_MASK(4, NCURSES_BUTTON_RELEASED)
##define	BUTTON4_PRESSED		NCURSES_MOUSE_MASK(4, NCURSES_BUTTON_PRESSED)
##define	BUTTON4_CLICKED		NCURSES_MOUSE_MASK(4, NCURSES_BUTTON_CLICKED)
##define	BUTTON4_DOUBLE_CLICKED	NCURSES_MOUSE_MASK(4, NCURSES_DOUBLE_CLICKED)
##define	BUTTON4_TRIPLE_CLICKED	NCURSES_MOUSE_MASK(4, NCURSES_TRIPLE_CLICKED)
#
#/*
# * In 32 bits the version-1 scheme does not provide enough space for a 5th
# * button, unless we choose to change the ABI by omitting the reserved-events.
# */
##if NCURSES_MOUSE_VERSION > 1
#
##define	BUTTON5_RELEASED	NCURSES_MOUSE_MASK(5, NCURSES_BUTTON_RELEASED)
##define	BUTTON5_PRESSED		NCURSES_MOUSE_MASK(5, NCURSES_BUTTON_PRESSED)
##define	BUTTON5_CLICKED		NCURSES_MOUSE_MASK(5, NCURSES_BUTTON_CLICKED)
##define	BUTTON5_DOUBLE_CLICKED	NCURSES_MOUSE_MASK(5, NCURSES_DOUBLE_CLICKED)
##define	BUTTON5_TRIPLE_CLICKED	NCURSES_MOUSE_MASK(5, NCURSES_TRIPLE_CLICKED)
#
##define	BUTTON_CTRL		NCURSES_MOUSE_MASK(6, 0001L)
##define	BUTTON_SHIFT		NCURSES_MOUSE_MASK(6, 0002L)
##define	BUTTON_ALT		NCURSES_MOUSE_MASK(6, 0004L)
##define	REPORT_MOUSE_POSITION	NCURSES_MOUSE_MASK(6, 0010L)
#
##else
#
##define	BUTTON1_RESERVED_EVENT	NCURSES_MOUSE_MASK(1, NCURSES_RESERVED_EVENT)
##define	BUTTON2_RESERVED_EVENT	NCURSES_MOUSE_MASK(2, NCURSES_RESERVED_EVENT)
##define	BUTTON3_RESERVED_EVENT	NCURSES_MOUSE_MASK(3, NCURSES_RESERVED_EVENT)
##define	BUTTON4_RESERVED_EVENT	NCURSES_MOUSE_MASK(4, NCURSES_RESERVED_EVENT)
#
##define	BUTTON_CTRL		NCURSES_MOUSE_MASK(5, 0001L)
##define	BUTTON_SHIFT		NCURSES_MOUSE_MASK(5, 0002L)
##define	BUTTON_ALT		NCURSES_MOUSE_MASK(5, 0004L)
##define	REPORT_MOUSE_POSITION	NCURSES_MOUSE_MASK(5, 0010L)
#
##endif
#
##define	ALL_MOUSE_EVENTS	(REPORT_MOUSE_POSITION - 1)
#
#/* macros to extract single event-bits from masks */
##define	BUTTON_RELEASE(e, x)		((e) & NCURSES_MOUSE_MASK(x, 001))
##define	BUTTON_PRESS(e, x)		((e) & NCURSES_MOUSE_MASK(x, 002))
##define	BUTTON_CLICK(e, x)		((e) & NCURSES_MOUSE_MASK(x, 004))
##define	BUTTON_DOUBLE_CLICK(e, x)	((e) & NCURSES_MOUSE_MASK(x, 010))
##define	BUTTON_TRIPLE_CLICK(e, x)	((e) & NCURSES_MOUSE_MASK(x, 020))
##define	BUTTON_RESERVED_EVENT(e, x)	((e) & NCURSES_MOUSE_MASK(x, 040))
#
#typedef struct
#{
#    short id;		/* ID to distinguish multiple devices */
#    int x, y, z;	/* event coordinates (character-cell) */
#    mmask_t bstate;	/* button state bits */
#}
#MEVENT;
#
#extern NCURSES_EXPORT(bool)    has_mouse(void);
#extern NCURSES_EXPORT(int)     getmouse (MEVENT *);
#extern NCURSES_EXPORT(int)     ungetmouse (MEVENT *);
#extern NCURSES_EXPORT(mmask_t) mousemask (mmask_t, mmask_t *);
#extern NCURSES_EXPORT(bool)    wenclose (const WINDOW *, int, int);
#extern NCURSES_EXPORT(int)     mouseinterval (int);
#extern NCURSES_EXPORT(bool)    wmouse_trafo (const WINDOW*, int*, int*, bool);
#extern NCURSES_EXPORT(bool)    mouse_trafo (int*, int*, bool);              /* generated */
#
##if NCURSES_SP_FUNCS
#extern NCURSES_EXPORT(bool)    NCURSES_SP_NAME(has_mouse) (SCREEN*);
#extern NCURSES_EXPORT(int)     NCURSES_SP_NAME(getmouse) (SCREEN*, MEVENT *);
#extern NCURSES_EXPORT(int)     NCURSES_SP_NAME(ungetmouse) (SCREEN*,MEVENT *);
#extern NCURSES_EXPORT(mmask_t) NCURSES_SP_NAME(mousemask) (SCREEN*, mmask_t, mmask_t *);
#extern NCURSES_EXPORT(int)     NCURSES_SP_NAME(mouseinterval) (SCREEN*, int);
##endif
#
##define mouse_trafo(y,x,to_screen) wmouse_trafo(stdscr,y,x,to_screen)
#
# }}}

# other stuff we probably won't use {{{
#
#/* other non-XSI functions */
#
#extern NCURSES_EXPORT(int) mcprint (char *, int);	/* direct data to printer */
#extern NCURSES_EXPORT(int) has_key (int);		/* do we have given key? */
#
##if NCURSES_SP_FUNCS
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(has_key) (SCREEN*, int);    /* do we have given key? */
#extern NCURSES_EXPORT(int) NCURSES_SP_NAME(mcprint) (SCREEN*, char *, int);	/* direct data to printer */
##endif
#
#/* Debugging : use with libncurses_g.a */
#
#extern NCURSES_EXPORT(void) _tracef (const char *, ...) GCC_PRINTFLIKE(1,2);
#extern NCURSES_EXPORT(void) _tracedump (const char *, WINDOW *);
#extern NCURSES_EXPORT(char *) _traceattr (attr_t);
#extern NCURSES_EXPORT(char *) _traceattr2 (int, chtype);
#extern NCURSES_EXPORT(char *) _nc_tracebits (void);
#extern NCURSES_EXPORT(char *) _tracechar (int);
#extern NCURSES_EXPORT(char *) _tracechtype (chtype);
#extern NCURSES_EXPORT(char *) _tracechtype2 (int, chtype);
##ifdef NCURSES_WIDECHAR
##define _tracech_t		_tracecchar_t
#extern NCURSES_EXPORT(char *) _tracecchar_t (const cchar_t *);
##define _tracech_t2		_tracecchar_t2
#extern NCURSES_EXPORT(char *) _tracecchar_t2 (int, const cchar_t *);
##else
##define _tracech_t		_tracechtype
##define _tracech_t2		_tracechtype2
##endif
#extern NCURSES_EXPORT(char *) _tracemouse (const MEVENT *);
#extern NCURSES_EXPORT(void) trace (const unsigned int);
#
#/* trace masks */
##define TRACE_DISABLE	0x0000	/* turn off tracing */
##define TRACE_TIMES	0x0001	/* trace user and system times of updates */
##define TRACE_TPUTS	0x0002	/* trace tputs calls */
##define TRACE_UPDATE	0x0004	/* trace update actions, old & new screens */
##define TRACE_MOVE	0x0008	/* trace cursor moves and scrolls */
##define TRACE_CHARPUT	0x0010	/* trace all character outputs */
##define TRACE_ORDINARY	0x001F	/* trace all update actions */
##define TRACE_CALLS	0x0020	/* trace all curses calls */
##define TRACE_VIRTPUT	0x0040	/* trace virtual character puts */
##define TRACE_IEVENT	0x0080	/* trace low-level input processing */
##define TRACE_BITS	0x0100	/* trace state of TTY control bits */
##define TRACE_ICALLS	0x0200	/* trace internal/nested calls */
##define TRACE_CCALLS	0x0400	/* trace per-character calls */
##define TRACE_DATABASE	0x0800	/* trace read/write of terminfo/termcap data */
##define TRACE_ATTRS	0x1000	/* trace attribute updates */
#
##define TRACE_SHIFT	13	/* number of bits in the trace masks */
##define TRACE_MAXIMUM	((1 << TRACE_SHIFT) - 1) /* maximum trace level */
#
##if defined(TRACE) || defined(NCURSES_TEST)
#extern NCURSES_EXPORT_VAR(int) _nc_optimize_enable;		/* enable optimizations */
#extern NCURSES_EXPORT(const char *) _nc_visbuf (const char *);
##define OPTIMIZE_MVCUR		0x01	/* cursor movement optimization */
##define OPTIMIZE_HASHMAP	0x02	/* diff hashing to detect scrolls */
##define OPTIMIZE_SCROLL		0x04	/* scroll optimization */
##define OPTIMIZE_ALL		0xff	/* enable all optimizations (dflt) */
##endif
#
##include <unctrl.h>
#
##ifdef __cplusplus
#
##ifndef NCURSES_NOMACROS
#
#/* these names conflict with STL */
##undef box
##undef clear
##undef erase
##undef move
##undef refresh
#
##endif /* NCURSES_NOMACROS */
#
#}
##endif
#
##endif /* __NCURSES_H */
#
# }}}

{.pop.}

