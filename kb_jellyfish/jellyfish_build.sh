#!/bin/bash

target=$target
if [[ $# -ne 0 ]] ; then
        target=$1
        shift
fi

IDIR=$target
JURL="http://kbase.us/docs/build/"
JBASE="jellyfish-1.1.5"

echo "###### downloading $JBASE ######"
wget $JURL$JBASE".tar.gz"
tar zxf $JBASE".tar.gz"

echo "###### installing $JBASE ######"
pushd $JBASE
./configure --prefix=$IDIR
make -j4
make install
popd
rm $JBASE".tar.gz"
rm -rf $JBASE

