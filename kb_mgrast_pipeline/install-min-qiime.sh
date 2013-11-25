#!/bin/sh
set -e

BOOTSTRAP_DIR=`pwd`
if [ $# -gt 0 ] ; then
        TARGET=$1
        shift
else
        TARGET=/kb/runtime
fi


# install qiime-uclust / qiime-dresee / qiime-blast
# 
# in order to install only minimal set of tools from qiime,
# use a modified qiime_1.5.0_uclust.conf 
# 
# in order to make qiime not break previous installed
# python lib, need to use a modified activate.sh

cd ${TARGET}
mkdir -p ${TARGET}/qiime
wget --no-clobber -t 5 --retry-connrefused --waitretry 5 ftp://thebeast.colorado.edu/pub/QIIME-v1.5.0-dependencies/app-deploy-qiime-1.5.0.tgz
tar zxvf app-deploy-qiime-1.5.0.tgz

cd app-deploy-qiime-1.5.0/etc
rm -f qiime_1.5.0_uclust.conf
# wget http://www.mcs.anl.gov/~wtang/files/qiime_1.5.0_uclust.conf
cp $BOOTSTRAP_DIR/qiime_1.5.0_uclust.conf .
cd ..
python app-deploy.py ${TARGET}/qiime -f etc/qiime_1.5.0_uclust.conf --force-remove-failed-dirs

cd ${TARGET}/qiime
rm -f activate.sh
# wget http://www.mcs.anl.gov/~wtang/files/activate.sh
cp $BOOTSTRAP_DIR/activate.sh .

# edit .bashrc for above apps
mkdir -p ${TARGET}/env
$BOOTSTRAP_DIR/activate.sh ${TARGET} > ${TARGET}/env/min-qiime-runtime-env.sh
