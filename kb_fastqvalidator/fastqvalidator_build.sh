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
# avoid tracking head of master
libStatGenTag='05f2a7e8bb8d0aa47d8814076c69df0b7cf44aeb'
fastQValidatorTag='2e8bfa61fb2cfb5f3ff4568ff0590228a7c6c1e7'

rm -rf libStatGen fastQValidator

echo "###### cloning $libStatGenURL ######"
git clone $libStatGenURL
echo "###### cloning $fastQValidatorURL ######"
git clone $fastQValidatorURL

echo "###### building $libStatGenURL with tag $libStatGenTag ######"
cd libStatGen
git checkout $libStatGenTag
make
cd ..

echo "###### building $fastQValidatorURL with tag $fastQValidatorTag ######"
cd fastQValidator
git checkout $fastQValidatorTag
make
cd ..


echo "###### installing $fastQValidatorURL ######"
cp ./fastQValidator/bin/fastQValidator $IDIR/bin/fastQValidator

rm -rf libStatGen fastQValidator
