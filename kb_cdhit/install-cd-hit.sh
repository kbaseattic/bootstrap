#!/bin/bash

dest=${TARGET-/kb/runtime}
echo "using $dest as installation directory";
mkdir -p $dest

# downlownload version
VERSION='v4.6.1-2012-08-27'
rm -rf cd-hit-${VERSION}*
wget "https://cdhit.googlecode.com/files/cd-hit-${VERSION}.tgz"
tar -zxvf cd-hit-${VERSION}.tgz

# compile and copy binaries
pushd cd-hit-${VERSION}
make
cp cd-hit cd-hit-est cd-hit-2d cd-hit-est-2d cd-hit-div cd-hit-454 $dest/bin
popd
rm -rf cd-hit-${VERSION}*
