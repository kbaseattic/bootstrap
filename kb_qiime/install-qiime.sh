#!/bin/bash

pushd source
for D in biom-format-0.9.3 PyCogent-1.5.1 PyNAST-1.1 Qiime-1.4.0; do
    pushd $D
    echo "###### installing $D ######"
    python setup.py install
    popd
done
popd
pushd bin
for B in `ls`; do 
    cp $B /usr/local/bin
done
popd