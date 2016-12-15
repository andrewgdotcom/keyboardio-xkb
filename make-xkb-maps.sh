#!/bin/bash

# A small script to generate a batch of key layout PDFs for multiple 
# keymap and geometry combinations.

# Keymap names can contain spaces, so use : as a separator instead
#
IFS=:

# See https://github.com/andrewgdotcom/keyboardio-xkb/ for geometry
# files that can be used with this script. These files should be copied
# (or better, soft linked) into /usr/share/X11/xkb/geometry/
#
GEOMETRY_LIST="keyboardio:keyboardio-abg"

# A list of system XKB keymaps to apply to each geometry.
#
KEYMAP_LIST="us:us dvorak:gb:fr:se:de:hu:it"

# We need to supply an ISO-8859-* locale for xkbprint, as it does not
# understand Unicode. Incant `locale -a` to see what ones you have.
# If you do not have one, you must generate one:
# 1) Pick an ISO-8859-* locale in /etc/locale.gen and uncomment it
# 2) run locale-gen
# 3) edit the below
# TODO: make this per-keymap.
#
XKBPRINT_LOCALE=en_IE.ISO-8859-15@euro

for geometry in $GEOMETRY_LIST; do
  for keymap in $KEYMAP_LIST; do
    # run $keymap through xargs to parse the embedded spaces
    echo $keymap |\
    xargs setxkbmap -geometry $geometry -print |\
    xkbcomp - - |\
    xkbprint -color -pict all -label symbols -lc $XKBPRINT_LOCALE - - |\
    ps2pdf - > $geometry-$keymap.pdf
  done
done

