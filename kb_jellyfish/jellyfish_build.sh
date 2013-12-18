#!/bin/bash

. ../tools/error_handler

trap 'error ${LINENO}' ERR

target=${TARGET-/kb/runtime}

if [[ $# -ne 0 ]] ; then
        target=$1
        shift
fi

IDIR=$target
JURL="http://www.cbcb.umd.edu/software/jellyfish/"
JBASE="jellyfish-1.1.11"

echo "###### downloading $JBASE ######"
curl -O $JURL$JBASE".tar.gz"

rm -rf $JBASE

tar zxf $JBASE".tar.gz"

echo "###### installing $JBASE ######"
pushd $JBASE
./configure --prefix=$IDIR
make -j4
make install
popd
rm $JBASE".tar.gz"
rm -rf $JBASE

