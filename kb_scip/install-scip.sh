#!/bin/bash

target=${TARGET-"/kb/runtime"}
if [[ $# -ne 0 ]] ; then
        target=$1
        shift
fi

IDIR=$target

if [ ! -e $IDIR/bin/scip ] ; mv scip $IDIR/bin/ ; fi
