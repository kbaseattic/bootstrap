#!/bin/sh
set -e

TARGET=/kb/runtime

#install bowtie and download index file
#sudo apt-get -y install bowtie

#install: superblat, blat, usearch
cp superblat ${TARGET}/bin
chmod +x ${TARGET}/bin/superblat

cp blat ${TARGET}/bin
chmod +x ${TARGET}/bin/blat

cp usearch ${TARGET}/bin
chmod +x ${TARGET}/bin/usearch
