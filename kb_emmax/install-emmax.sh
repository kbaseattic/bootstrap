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
    url="http://www.sph.umich.edu/csg/kang/emmax/download/emmax-intel-binary-20120210.tar.gz"
fi

file=`basename $url`
#dir=`echo $file | sed -e 's/\.tgz$//'`

curl -f -o $file $url
if [ $? -ne 0 -o ! -f $file ] ; then
    echo "Curl of $url to $file failed" 1>&2
    exit 1
fi

tar -xzf $file

if [ $? -ne 0 -o ! -f "emmax-intel64" ] ; then
    echo "Unpack of $file failed" 1>&2
    exit 1
fi

cp emmax-intel64 $dest/bin/emmax
cp emmax-kin-intel64 $dest/bin/emmax-kin
