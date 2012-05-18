#!/bin/sh

export JAVA_HOME=/kb/runtime/java
export ANT_HOME=/kb/runtime/ant
export THRIFT_HOME=/kb/runtime/thrift
export PATH=${JAVA_HOME}/bin:${ANT_HOME}/bin:/kb/runtime/bin:${THRIFT_HOME}/bin:${PATH}

curl http://www.kbase.us/docs/build/thrift-0.8.0.tar.gz > thrift-0.8.0.tar.gz
tar zxvf thrift-0.8.0.tar.gz
cd thrift-0.8.0
./configure --prefix=/kb/runtime/thrift-0.8.0
make
make install
ln -s /kb/runtime/thrift-0.8.0 /kb/runtime/thrift
