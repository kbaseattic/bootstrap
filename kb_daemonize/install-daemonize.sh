#!/bin/bash

target="/kb/runtime"
if [[ $# -ne 0 ]] ; then
        target=$1
        shift
fi

IDIR=$target

# download and install daemonize
git clone git://github.com/bmc/daemonize.git
pushd daemonize
./configure --prefix=$IDIR
make
make install
popd
rm -rf daemonize