#!/bin/bash

dest=${TARGET-/kb/runtime}
echo "using $dest as installation directory";
mkdir -p $dest

# downlownload version
VERSION='2.2.2'
rm -rf bowtie2-${VERSION}*
wget "http://sourceforge.net/projects/bowtie-bio/files/bowtie2/${VERSION}/bowtie2-${VERSION}-source.zip"
unzip bowtie2-${VERSION}-source.zip

# compile and copy binaries
pushd bowtie2-${VERSION}
make
cp bowtie2 bowtie2-align-l bowtie2-align-s bowtie2-build bowtie2-build-l bowtie2-build-s bowtie2-inspect bowtie2-inspect-l bowtie2-inspect-s $dest/bin
popd

