#!/bin/bash

if [[ $# != 1 ]] ; then
    echo "Usage: $0 python-qiime-list" 1>&2
    exit 1
fi

pkg_list=$1
IFS=$'\t'

while read PKG TGZ URL; do
    echo "###### downloading $PKG ######"
    wget $URL
    tar zxf $TGZ
    pushd $PKG
    echo "###### installing $PKG ######"
    python setup.py install
    popd
    rm $TGZ
    rm -rf $PKG
done < $pkg_list

pushd bin
for B in `ls`; do 
    cp $B /kb/runtime/bin/.
done
popd
