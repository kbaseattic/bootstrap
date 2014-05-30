#!/bin/bash

dest=${TARGET-/kb/runtime}
echo "using $dest as installation directory";
mkdir -p $dest

# downlownload version

rm -rf bowtie2-2.2.2*
wget "http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.2/bowtie2-2.2.2-source.zip"
unzip bowtie2-2.2.2-source.zip
pushd bowtie2-2.2.2
make
cp bowtie2 bowtie2-align-l bowtie2-align-s bowtie2-build bowtie2-build-l bowtie2-build-s bowtie2-inspect bowtie2-inspect-l bowtie2-inspect-s $dest/bin
popd
rsync -avz --exclude '*.h' --exclude '*.cpp' bowtie2-2.2.2 $dest

