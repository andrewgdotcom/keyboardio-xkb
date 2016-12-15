#!/bin/bash

IFS=:
KEYMAP_LIST="us:us dvorak:gb:fr:se:de:hu:it"
GEOMETRY_LIST="keyboardio:keyboardio-abg"

for geometry in $GEOMETRY_LIST; do
  sudo cp ~/Dropbox/stuff/xkb-geometry-$geometry /usr/share/X11/xkb/geometry/$geometry

  for keymap in $KEYMAP_LIST; do
    # run $keymap through xargs to parse the embedded spaces
    echo $keymap | xargs setxkbmap -geometry $geometry -print | xkbcomp - - | xkbprint -color -pict all -label symbols -lc en_IE.ISO-8859-15@euro - - | ps2pdf - > $geometry-$keymap.pdf
  done
done

