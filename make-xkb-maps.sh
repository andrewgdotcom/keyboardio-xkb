#!/bin/bash

# A small script to generate a batch of key layout PDFs for multiple 
# keymap and geometry combinations.

# Keymap names can contain spaces, so use comma as a separator instead
#
IFS=,

# See https://github.com/andrewgdotcom/keyboardio-xkb/keyboardio_vndr/
# for files that can be used with this script. This directory should be
# soft linked under /usr/share/X11/xkb/geometry/ :
#
# sudo ln -s $GIT_PATH/keyboardio_vndr /usr/share/X11/xkb/geometry/
#
GEOMETRY_LIST="keyboardio_vndr/01,keyboardio_vndr/01-abg"

# A list of system XKB keymaps to apply to each geometry. To find a 
# list of these, run `man xkeyboard-config`. They are listed under
# "Layouts" and variants are given in parenthesis. For the purposes of
# this script, both variants and options are separated from the parent 
# keymap by spaces, e.g. 
# 
# "us(dvorak)" with option "compose:menu" -> "us dvorak compose:menu"
#
KEYMAP_LIST="us,us dvorak compose:menu,gb,fr,se,de,hu,it"

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
  geometry_sane=$(tr "/" "_" <<<$geometry)
  
  for keymap in $KEYMAP_LIST; do
    keymap_sane=$(tr " " "_" <<<$keymap)

    # run $keymap through xargs to parse the embedded spaces
    echo $keymap |\
    xargs setxkbmap -geometry $geometry -print |\
    xkbcomp - - |\
    xkbprint -color -pict all -label symbols -lc $XKBPRINT_LOCALE - - |\
    ps2pdf - > xkb-${geometry_sane}-${keymap_sane}.pdf
    # also generate a png
    pdftoppm -png xkb-${geometry_sane}-${keymap_sane}.pdf \
		> xkb-${geometry_sane}-${keymap_sane}.png
  done
done

