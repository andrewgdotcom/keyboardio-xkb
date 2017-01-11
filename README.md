# keyboardio-xkb
Some Linux XKB files for use with the Keyboardio Model 01

* 01.template - the XKB geometry template for the Keyboardio Model 01
* layout-variants/ - easy config files for layouts to apply to the template
* keyboardio_vndr - precompiled XKB geometries for use with xkbprint
* make-geometry-variants.sh - generates geometries from the template
* make-xkb-maps.sh - generates layout PDFs and PNGs from the geometries
* xfree86-scancodes - US-ASCII annotated XKB scancode file for reference

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
and run the make-xkb-maps.sh script in a temporary directory. This will 
generate PDFs and PNGs of each geometry as it appears under each keymap.

Terminology
-----------

There are so many layers of abstraction involved in HIDs that the terminology
can get complicated. The following are reasonably standard:

* *geometry* - this is the physical location of the keys on the keyboard.
	An XKB geometry file contains a vector representation of the keyboard
	annotated with one or more XKB scancode aliases for each key.
* *scancode* - each abstraction layer in the stack uses its own scancodes,
	which are typically single bytes or escape sequences of multiple 
	bytes. A keyboard may use custom scancodes
	internally before translating them into USB or PS2 scancodes for
	transmission across the appropriate peripheral bus. These are
	then usually standardised by the kernel into an OS-specific scancode 
	set. In XKB (which is cross-platform), the OS native scancodes are 
	further standardised into XKB aliases (which unlike native or bus 
	scancodes are alphanumeric). 
* *keymap* - this is the user-customisable layer at the top of the stack which
	allows the scancodes to generate a human-readable letter or event
	such as "k" or "page down".

I am also using the following definition for the purposes of this project:

* *layout* - a mapping (in keyboard firmware) of bus scancodes to physical 
	keys (strictly, the keyboard native scancode). In this project
	I am using XKB scancode aliases rather than bus scancodes, however:
	a) these have a 1:1 mapping (under the majority of circumstances!) 
	onto bus scancodes such as USB, which is what the Keyboardio Model 01 
	actually emits, and b) XKB aliases are much more user-friendly to
	play around with in config files.

("Layout" is used inconsistently in other literature to refer to various
combinations of the above)

Note
----

This strictly applies only to linux, but there are minimal differences between
OSes using common keymaps, so they should be of general interest.

If you have a custom layout that you want me to include, send a pull request
or email me at andrewg@andrewg.com.

