#!/bin/sh

target=${TARGET-/kb/runtime}

if [[ $# -gt 0 ]] ; then
	target=$1
	shift
fi

if [[ -d /Library/Java/Home ]] ; then
	export JAVA_HOME=/Library/Java/Home
else
	export JAVA_HOME=$runtime/java
fi
export ANT_HOME=$target/ant
export THRIFT_HOME=$target/thrift
export PATH=${JAVA_HOME}/bin:${ANT_HOME}/bin:$target/bin:${THRIFT_HOME}/bin:${PATH}
export PY_PREFIX=$target

curl -O -L http://www.kbase.us/docs/build/thrift-0.8.0.tar.gz 
tar zxvf thrift-0.8.0.tar.gz
cd thrift-0.8.0
./configure --prefix=$target/thrift-0.8.0
make
make install
ln -s $target/thrift-0.8.0 $target/thrift
