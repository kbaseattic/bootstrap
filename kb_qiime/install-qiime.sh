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

# python libs
while read TYPE PKG SRC; do
    echo "downloading $PKG via $TYPE"
    if [[ $TYPE == 'svn' ]]; then
        svn co $SRC $PKG
    elif [[ $TYPE == 'git' ]]; then
        git clone $SRC
    fi
    if [[ ! -d $PKG ]] ; then
        echo "Download of $SRC did not create $PKG directory" 1>&2
        exit 2
    fi
    echo "installing $PKG"
    pushd $PKG
    $python setup.py install
    popd
done < $pkg_list

# java rdp clasifier
echo "installing rdp-classifier"
wget -O rdp_classifier_2.2.zip http://sourceforge.net/projects/rdp-classifier/files/rdp-classifier/rdp_classifier_2.2.zip/download
unzip -d $target/ rdp_classifier_2.2.zip
ln -s $runtime/rdp_classifier_2.2/rdp_classifier-2.2.jar $runtime/lib/rdp_classifier.jar
ln -s $runtime/rdp_classifier_2.2/rdp_classifier-2.2.jar $runtime/java/lib/rdp_classifier.jar

# pre-compiled 64-bit Linux
for B in bin/*; do 
    echo "install $B"
    cp $B $target/bin/.
done
