#!/bin/bash

target=${TARGET-/kb/runtime}
if [[ $# -ne 0 ]] ; then
        target=$1
        shift
fi

IDIR=$target
CURL="http://kbase.us/docs/build/"
CBASE="distribute_setup.py"

echo "###### downloading $CBASE ######"
curl -O $CURL$CBASE

echo "###### installing python distribute  ######"
python distribute_setup.py

echo "###### installing nose for python  ######"
easy_install nose

CBASE="screed"

echo "###### downloading $CBASE ######"
curl -O $CURL$CBASE".tar.gz"
tar zxf $CBASE".tar.gz"

echo "###### installing $CBASE ######"
pushd $CBASE
python setup.py install
popd
rm $CBASE".tar.gz"
rm -rf $CBASE

CBASE="khmer"

echo "###### downloading $CBASE ######"
curl -O $CURL$CBASE".tar.gz"
tar zxf $CBASE".tar.gz"

echo "###### installing $CBASE ######"
pushd $CBASE
make clean all
echo 'export PYTHONPATH=/kb/dev_container/modules/docs/build/khmer/python' >> /home/ubuntu/.bashrc
popd
rm $CBASE".tar.gz"
rm -rf $CBASE

CBASE="MUMmer3.23"

echo "###### downloading $CBASE ######"
curl -O $CURL$CBASE".tar.gz"
tar zxf $CBASE".tar.gz"

echo "###### installing $CBASE ######"
pushd $CBASE
make check
make install
echo 'export PATH=$PATH:/kb/dev_container/modules/docs/build/MUMmer3.23' >> /home/ubuntu/.bashrc
cp /kb/dev_container/modules/docs/build/MUMmer3.23/show-coords /usr/local/bin/
popd
rm $CBASE".tar.gz"
rm -rf $CBASE

CBASE="cd-hit-v4.5.7-2011-12-16"

echo "###### downloading $CBASE ######"
curl -O $CURL$CBASE".tar.gz"
tar zxf $CBASE".tar.gz"

echo "###### installing $CBASE ######"
pushd $CBASE
make
make install
popd
rm $CBASE".tar.gz"
rm -rf $CBASE

CBASE="amos-3.1.0-rc1"

echo "###### downloading $CBASE ######"
curl -O $CURL$CBASE".tar.gz"
tar zxf $CBASE".tar.gz"

echo "###### installing $CBASE ######"
pushd $CBASE
./configure
make
make install
cp bin/* /usr/local/bin
popd
rm $CBASE".tar.gz"
rm -rf $CBASE

CBASE="velvet_1.2.08"

echo "###### downloading $CBASE ######"
curl -O $CURL$CBASE".tar.gz"
tar zxf $CBASE".tar.gz"

echo "###### installing $CBASE ######"
pushd $CBASE
make 'MAXKMERLENGTH=71'
popd
rm $CBASE".tar.gz"
rm -rf $CBASE
