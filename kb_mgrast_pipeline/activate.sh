#!/bin/bash
if [ $# -gt 0 ] ; then
        TARGET=$1
        shift
else
        TARGET=/kb/runtime
fi


echo "
export SEQ_LOOKUP_FILE=$TARGET/qiime/ampliconnoise-1.25-release/Data/Tran.dat
export QIIME=$TARGET/qiime/qiime-1.5.0-release/./
export PYTHONPATH=$TARGET/qiime/qiime-1.5.0-release/lib/python2.7/site-packages:$TARGET/qiime/qiime-1.5.0-release/lib/:$TARGET/qiime/matplotlib-1.1.0-release/lib/python2.7/site-packages:$TARGET/qiime/pycogent-1.5.1-release/lib/python2.7/site-packages:$TARGET/qiime/numpy-1.5.1-release/lib/python2.7/site-packages:$TARGET/qiime/setuptools-0.6c11-release/lib/python2.7/site-packages:$PYTHONPATH
export TEST_DB=1
export BLASTMAT=$TARGET/qiime/blast-2.2.22-release/data
export PYCOGENT=$TARGET/qiime/pycogent-1.5.1-release/./
export QIIME_CONFIG_FP=~/.qiime_config_default
export PATH=$PATH:$TARGET/qiime/qiime-1.5.0-release/bin:$TARGET/qiime/python-2.7.1-release/bin:$TARGET/qiime/blast-2.2.22-release/bin:$TARGET/qiime/drisee-1.2-release/.:$TARGET/qiime/uclust-1.2.22-release/.
"
