#!/bin/bash

. ../tools/error_handler

trap 'error ${LINENO}' ERR

target=${TARGET-/kb/runtime}

if [[ $# -ne 0 ]] ; then
        target=$1
        shift
fi

IDIR=$target
CURL="http://sourceforge.net/projects/cdbfasta/files/latest/download?source=files"
CBASE="cdbfasta"

echo "###### downloading $CBASE ######"
curl -L $CURL > $CBASE".tar.gz"
tar zxf $CBASE".tar.gz"

echo "###### installing $CBASE ######"
pushd $CBASE
make
cp cdbfasta $IDIR/bin/.
cp cdbyank $IDIR/bin/.
popd
rm $CBASE".tar.gz"
rm -rf $CBASE

