#!/bin/bash

dest=${TARGET-/kb/runtime}

if [ $# -gt 0 ] ; then
    dest=$1
    shift
fi

if [ ! -d "$dest/bin" ] ; then
    mkdir $dest/bin 
    echo "$dest/bin created" 1>&2
fi

if [ -d "/Library" ] ; then
    echo "NOT supported on OSX"
    exit 0
else
    url="http://genetics.cs.ucla.edu/emmax/emmax-beta-07Mar2010.tar.gz"
fi

file=`basename $url`
dir=`echo $file | sed -e 's/\.tar\.gz$//'`

curl -f -o $file $url
if [ $? -ne 0 -o ! -f $file ] ; then
    echo "Curl of $url to $file failed" 1>&2
    exit 1
fi

tar -xzf $file

if [ $? -ne 0 -o ! -f "$dir/emmax" ] ; then
    echo "Unpack of $file failed" 1>&2
    exit 1
fi

cp $dir/emmax $dest/bin/emmax
cp $dir/emmax-kin $dest/bin/emmax-kin
