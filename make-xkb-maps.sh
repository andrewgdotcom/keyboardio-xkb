#!/bin/bash

# A small script to generate a batch of key layout PDFs for multiple
# keymap and geometry combinations.

# See https://github.com/andrewgdotcom/keyboardio-xkb/keyboardio_vndr/
# for files that can be used with this script. This directory should be
# soft linked under /usr/share/X11/xkb/geometry/ :
#
#   sudo ln -s $GIT_PATH/keyboardio_vndr /usr/share/X11/xkb/geometry/
#
# A list of system XKB keymaps to apply to each geometry. To find a
# list of these, run `man xkeyboard-config`. They are listed under
# "Layouts" and variants are given in parenthesis. For the purposes of
# this script, both variants and options are separated from the parent
# keymap by "+", e.g.
#
#   "us(dvorak)" with option "compose:menu" -> "us+dvorak+compose:menu"
#
# If we need different locales for different keymaps, then we can
# suffix those keymaps with their preferred locale, delimited by a
# semicolon.

GEOMETRY_LIST="
keyboardio_vndr/01-default:	us gb us+dvorak
keyboardio_vndr/01-merlin2:	us+dvorak fr fr+bepo se de it hu;hu_HU.ISO88592
keyboardio_vndr/01-ngetal2:	us gb pl
keyboardio_vndr/01-latam:	latam
keyboardio_vndr/01-brazil:	br
keyboardio_vndr/01-merlin3:	es
"
# Japanese not currently working
#keyboardio_vndr/01-japan:	ja

# Most modern installs use a UTF-8 locale by default, but xkbprint does
# not understand unicode. We must therefore explicitly configrure an 
# ISO-8859-* locale. Incant `locale -a` to see what ones you have.
# If you do not have one, you must generate one:
#
# 1) Pick an ISO-8859-* locale in /etc/locale.gen and uncomment it
# 2) run locale-gen
#
# Note that the locale format is slightly different in /etc/locale.gen
# Be sure to use the format returned by `locale -a` below
#
# In most cases, it is sufficient to set the DEFAULT_LOCALE.
#
DEFAULT_LOCALE=en_IE.ISO885915@euro

# OK, let's go for it

IFS_SAVE=$IFS
IFS="
"
for GEOMETRY_ENTRY in $GEOMETRY_LIST; do
  IFS=$IFS_SAVE

  geometry=${GEOMETRY_ENTRY%:*}
  KEYMAP_LIST=${GEOMETRY_ENTRY#*:}
  
  # we need a sanitised identifier for generating filenames
  geometry_sane=$(tr "/" "_" <<<$geometry)

  for pair in $KEYMAP_LIST; do
    entries=(${pair//;/ })
    keymap=${entries[0]}
    XKBPRINT_LOCALE=${entries[1]}
    if [[ -z "$XKBPRINT_LOCALE" ]]; then
      XKBPRINT_LOCALE=$DEFAULT_LOCALE
    fi
    LANG=$XKBPRINT_LOCALE

    # run $keymap through xargs to split into words
    echo ${keymap//+/ } |\
    xargs setxkbmap -geometry $geometry -print |\
    xkbcomp - - |\
    xkbprint -color -pict all -label symbols -lc $XKBPRINT_LOCALE - - |\
    ps2pdf - > xkb-${geometry_sane}-$keymap.pdf
    # also generate a png
    pdftoppm -png xkb-${geometry_sane}-$keymap.pdf \
		> xkb-${geometry_sane}-$keymap.png
  done
done

