#!/bin/bash

. ../tools/error_handler

trap 'error ${LINENO}' ERR

target=${TARGET-/kb/runtime}

if [[ $# -ne 0 ]] ; then
        target=$1
        shift
fi

IDIR=$target
libStatGenURL='https://github.com/statgen/libStatGen'
fastQValidatorURL='https://github.com/statgen/fastQValidator'
# the official releases are too old, use a github tag to
# avoid tracking master
libStatGenTag=''
fastQValidatorTag=''

rm -rf libStatGen fastQValidator

echo "###### cloning $libStatGenURL ######"
git clone $libStatGenURL
echo "###### cloning $fastQValidatorURL ######"
git clone $fastQValidatorURL

echo "###### building $libStatGenURL ######"
cd libStatGen
git checkout $libStatGenTag
make
cd ..

echo "###### building $fastQValidatorURL ######"
cd fastQValidator
git checkout $fastQValidatorTag
make
cd ..


echo "###### installing $fastQValidatorURL ######"
cp ./fastQValidator/bin/fastQValidator $IDIR/bin

rm -rf libStatGen fastQValidator
