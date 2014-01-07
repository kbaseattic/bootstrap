#!/bin/sh
set -e

if [ $# -gt 0 ] ; then
        TARGET=$1
        shift
else
	TARGET=/kb/runtime
fi

#install: superblat, usearch
cp bin/superblat ${TARGET}/bin
chmod +x ${TARGET}/bin/superblat

cp bin/usearch ${TARGET}/bin
chmod +x ${TARGET}/bin/usearch
