#!/bin/bash

target="/kb/runtime"
if [[ $# -ne 0 ]] ; then
        target=$1
        shift
fi

IDIR=$target
CURL="http://kbase.us/docs/build/"
CBASE="cdbfasta"

echo "###### downloading $CBASE ######"
wget $CURL$CBASE".tar.gz"
tar zxf $CBASE".tar.gz"

echo "###### installing $CBASE ######"
pushd $CBASE
make
cp cdbfasta $IDIR/bin/.
cp cdbyank $IDIR/bin/.
popd
rm $CBASE".tar.gz"
rm -rf $CBASE

