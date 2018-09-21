#!/bin/bash

# The logical layout of the model 01 is as follows:

# Left hand
# r0c0  r0c1  r0c2  r0c3  r0c4  r0c5  r0c6  r0c7
# r1c0  r1c1  r1c2  r1c3  r1c4  r1c5  r1c6  r1c7
# r2c0  r2c1  r2c2  r2c3  r2c4  r2c5  r2c6  r2c7
# r3c0  r3c1  r3c2  r3c3  r3c4  r3c5  r3c6  r3c7

#             Right hand
#             r0c8  r0c9  r0c10 r0c11 r0c12 r0c13 r0c14 r0c15
#             r1c8  r1c9  r1c10 r1c11 r1c12 r1c13 r1c14 r1c15
#             r2c8  r2c9  r2c10 r2c11 r2c12 r2c13 r2c14 r2c15
#             r3c8  r3c9  r3c10 r3c11 r3c12 r3c13 r3c14 r3c15


# This corresponds to a physical layout:

# Left hand
# r0c0  r0c1  r0c2  r0c3  r0c4  r0c5  r0c6              # LR0
# r1c0  r1c1  r1c2  r1c3  r1c4  r1c5  r1c6              # LR1
# r2c0  r2c1  r2c2  r2c3  r2c4  r2c5  r2c6              # LR2
# r3c0  r3c1  r3c2  r3c3  r3c4  r3c5                    # LR3
#
#                           r0c7 r1c7 r2c7 r3c7	        # LTH
#                                     r3c6              # LPA

#             Right hand								
#             r0c9  r0c10 r0c11 r0c12 r0c13 r0c14 r0c15 # RR0 
#             r1c9  r1c10 r1c11 r1c12 r1c13 r1c14 r1c15 # RR1 
#             r2c9  r2c10 r2c11 r2c12 r2c13 r2c14 r2c15 # RR2 
#                   r3c10 r3c11 r3c12 r3c13 r3c14 r3c15 # RR3 
#                                                       
#        r3c8 r2c8 r1c8 r0c8                            # RTH 
#             r3c9                                      # RPA

mkdir -p keyboardio_vndr

for VARIANT in $(ls layout-variants); do

  # in the default case, this loads the default twice. Never mind.
  . layout-variants/default
  . layout-variants/$VARIANT

  # prepopulate the list of mappings with the palm keys
  MAPPINGS="s/\<R3C6\>/\<${LPA}\>/g; s/\<R3C9\>/\<${RPA}\>/g"

  # now the thumb keys
  row=0
  for alias in $LTH; do
    MAPPINGS="${MAPPINGS}; s/\<R${row}C7\>/\<${alias}\>/g"
    let row++
  done
  
  for alias in $RTH; do
    let row--
    MAPPINGS="${MAPPINGS}; s/\<R${row}C8\>/\<${alias}\>/g"
  done

  # now the short rows
  column=0
  for alias in $LR3; do
    MAPPINGS="${MAPPINGS}; s/\<R3C${column}\>/\<${alias}\>/g"
    let column++
  done
  
  # skip over the palm keys and thumb rows
  let column=column+4
  
  for alias in $RR3; do
    MAPPINGS="${MAPPINGS}; s/\<R3C${column}\>/\<${alias}\>/g"
    let column++
  done

  # and now the rest of the rows
  for row in 0 1 2; do
	  column=0
	  
	  rowname="LR${row}"
	  for alias in ${!rowname}; do
	    MAPPINGS="${MAPPINGS}; s/\<R${row}C${column}\>/\<${alias}\>/g"
	    let column++
	  done
	  
	  # skip over the thumb rows
	  let column=column+2
	  
	  rowname="RR${row}"
	  for alias in ${!rowname}; do
	    MAPPINGS="${MAPPINGS}; s/\<R${row}C${column}\>/\<${alias}\>/g"
	    let column++
	  done

  done

  # apply the mappings to the template and output a variant geometry
  perl -pe "$MAPPINGS" 01.template > keyboardio_vndr/01-$VARIANT

done
