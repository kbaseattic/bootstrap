#!/bin/sh
set -e

if [ $# -gt 0 ] ; then
        TARGET=$1
        shift
else
	TARGET=/kb/runtime
fi

#install bowtie and download index file
#sudo apt-get -y install bowtie

#install: superblat, blat, usearch
cp superblat ${TARGET}/bin
chmod +x ${TARGET}/bin/superblat

cp blat ${TARGET}/bin
chmod +x ${TARGET}/bin/blat

cp usearch ${TARGET}/bin
chmod +x ${TARGET}/bin/usearch
