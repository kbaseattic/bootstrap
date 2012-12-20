#!/bin/bash

python=python
target=/kb/runtime

if [[ $# -eq 1 ]] ; then
    pkg_list=$1
elif [[ $# -eq 2 ]] ; then
    pkg_list=$1
    target=$2
    python=$target/bin/python
else 
    echo "Usage: $0 python-qiime-list [target-runtime-dir]" 1>&2
    exit 1
fi

IFS=$'\t'

while read PKG TGZ URL; do
    echo "###### downloading $PKG ######"
    if [[ ! -f $TGZ ]] ; then
	    curl -L -O $URL
    fi
    tar zxf $TGZ
    if [[ ! -d $PKG ]] ; then
	echo "Download of $URL and extraction of $TGZ did not create $PKG directory" 1>&2
	exit 2
    fi
    echo "###### installing $PKG ######"
    (cd $PKG; $python setup.py install)
done < $pkg_list

for B in bin/*; do 
    echo "install $B"
    cp $B $target/bin/.
done
