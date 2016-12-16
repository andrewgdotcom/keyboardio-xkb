# keyboardio-xkb
Some Linux XKB files for use with the Keyboardio Model 01

* 01.template: the XKB geometry template for the Keyboardio Model 01
* layout-variants/: easy config files for layouts to apply to the template
* keyboardio_vndr: precompiled XKB geometries for use with xkbprint
* make-geometry-variants.sh: script to generate geometries from the template
* make-xkb-maps.sh: Generate layout PDFs and PNGs from the geometries
* xfree86-scancodes: US-ASCII annotated XKB scancode file for reference

How to use
==========

git-clone the repository and soft link the subdirectory keyboardio_vndr under
/usr/share/X11/xkb/geometry/. This contains some prebuilt geometry files.

Now create your own layout in variant-layouts. Use the default as a guide.
It should be self-explanatory.

Now run the script make-geometry-variants in the root of the repo. This will
populate the keyboardio_vndr directory with geometry files corresponding to
each variant-layout config file. These are now usable by the system.

To see how linux system keymaps will behave under each firmware layout, edit
and run the make-xkb-maps.sh script. This will generate PDFs and PNGs of 
each geometry as it appears under each keymap.

Note
----

This strictly applies only to linux, but there are few differences between the 
most common keymaps across OSes, so they will be of general interest.

If you have a custom keymap that you want me to include, send a pull requests
or email me at andrewg@andrewg.com.

