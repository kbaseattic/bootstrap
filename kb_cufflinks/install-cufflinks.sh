#!/bin/bash

dest=${TARGET-/kb/runtime}
echo "using $dest as installation directory";
mkdir -p $dest

# downlownload version
VERSION='2.2.1'
rm -rf cufflinks-${VERSION}*
wget "http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-${VERSION}.Linux_x86_64.tar.gz"
tar -xzvf cufflinks-${VERSION}.Linux_x86_64.tar.gz
rm cufflinks-${VERSION}.Linux_x86_64.tar.gz
# compile and copy binaries
pushd cufflinks-${VERSION}.Linux_x86_64
#make
cp `find . -maxdepth 1 -perm -111 -type f` ${dest}/bin
popd
rm -rf cufflinks-${VERSION}.Linux_x86_64
