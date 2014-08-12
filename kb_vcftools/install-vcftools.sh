#!/bin/bash

dest=${TARGET-/kb/runtime}
echo "using $dest as installation directory";
mkdir -p $dest

# downlownload version

rm -rf vcftools_0.1.12*
wget  "http://iweb.dl.sourceforge.net/project/vcftools/vcftools_0.1.12a.tar.gz"
tar -zxvf vcftools_0.1.12a.tar.gz
pushd vcftools_0.1.12a
make
cp -pr bin/* ${dest}/bin
popd

