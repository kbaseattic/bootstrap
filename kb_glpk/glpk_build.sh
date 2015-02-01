#!/bin/bash

. ../tools/error_handler

trap 'error ${LINENO}' ERR

target=${TARGET-/kb/runtime}

if [[ $# -ne 0 ]] ; then
        target=$1
        shift
fi

IDIR=$target
URL="ftp://ftp.gnu.org/gnu/glpk/"
BASE="glpk-4.45"

echo "###### downloading $BASE ######"
curl -O $URL$BASE".tar.gz"

rm -rf $BASE

tar zxf $BASE".tar.gz"

echo "###### installing $BASE ######"
pushd $BASE
./configure --prefix=$IDIR
make -j4
make install
popd
rm $BASE".tar.gz"
rm -rf $BASE

