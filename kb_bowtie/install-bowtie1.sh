#!/bin/bash

dest="/kb/runtime"
echo "using $dest as installation directory";
mkdir -p $dest

# downlownload version

rm -rf bowtie-1.0.0*
wget  "http://sourceforge.net/projects/bowtie-bio/files/bowtie/1.0.0/bowtie-1.0.0-src.zip"
unzip bowtie-1.0.0-src.zip
pushd bowtie-1.0.0
make
cp bowtie bowtie-build bowtie-inspect $dest/bin
popd
rsync -avz --exclude '*.h' --exclude '*.cpp' bowtie-1.0.0 $dest


# option 1
# ln -s $dest/bowtie/* $dest/bin/.


# optoin 2
echo "export BOWTIE-1_HOME=$dest/bowtie-1.0.0" > $dest/env/bowtie1-runtime-env.sh
echo "export PATH=\$PATH:\$BOWTIE-1_HOME:\$BOWTIE-1_HOME/scripts" >> $dest/env/bowtie1-runtime-env.sh
