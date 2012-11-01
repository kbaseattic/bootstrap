#!/bin/bash

dest=/kb/runtime

if [ $# -gt 0 ] ; then
    dest=$1
    shift
fi

if [ ! -d "$dest/bin" ] ; then
    echo "$dest/bin is not a directory" 1>&2
    exit 1
fi

if [ -d "/Library" ] ; then
    url="http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.2.1.tgz"
else
    url="http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.0.7.tgz"
fi

file=`basename $url`
dir=`echo $file | sed -e 's/\.tgz$//'`

curl -f -o $file $url
if [ $? -ne 0 -o ! -f $file ] ; then
    echo "Curl of $url to $file failed" 1>&2
    exit 1
fi

tar -xzf $file

if [ $? -ne 0 -o ! -f "$dir/bin/mongod" ] ; then
    echo "Unpack of $file to $dir failed" 1>&2
    exit 1
fi

cp $dir/bin/* $dest/bin/.

