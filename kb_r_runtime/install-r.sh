#!/bin/bash

if [[ $# != 1 ]] ; then
    echo "Usage: $0 r-packages.R" 1>&2
    exit 1
fi

RLIB=$1
RURL="http://cran.r-project.org/src/base/R-2/"
RBASE="R-2.15.1"

echo "###### downloading $RBASE ######"
wget $RURL$RBASE".tar.gz"
tar zxf $RBASE".tar.gz"
pushd $RBASE
echo "###### installing $RBASE ######"
./configure --enable-R-shlib
make -j4
make install
popd
rm $RBASE".tar.gz"
rm -rf $RBASE

echo "###### installing r-recommended ######"
apt-get -y install r-recommended

echo "###### installing R libraries ######"
R CMD BATCH $RLIB
