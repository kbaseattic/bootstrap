#!/bin/sh
set -x

. ../tools/error_handler

trap 'error ${LINENO}' ERR

target=${TARGET-/kb/runtime}

if [[ $# -gt 0 ]] ; then
	target=$1
	shift
fi

opts=""
if [[ -x /usr/libexec/java_home ]] ; then
	if /usr/libexec/java_home ; then
		export JAVA_HOME=`/usr/libexec/java_home`
	else
		opts="$opts --without-java"
	fi
	opts="$opts --without-ruby"
	opts="$opts --without-php"
elif [[ -d /Library/Java/Home ]] ; then
	export JAVA_HOME=/Library/Java/Home
	opts="$opts --without-ruby"
else
	export JAVA_HOME=$runtime/java
fi
export ANT_HOME=$target/ant
export THRIFT_HOME=$target/thrift
export PATH=${JAVA_HOME}/bin:${ANT_HOME}/bin:$target/bin:${THRIFT_HOME}/bin:${PATH}
export PY_PREFIX=$target

vers=0.8.0
url=http://www.kbase.us/docs/build/thrift-$vers.tar.gz

#vers=0.9.1
#url=http://apache.spinellicreations.com/thrift/$vers/thrift-$vers.tar.gz

tar=thrift-$vers.tar.gz

curl -o $tar -L $url

rm -rf thrift-$vers
tar zxf $tar

cd thrift-$vers
./configure --prefix=$target/thrift-$vers $opts
make
make install
rm -f $target/thrift
ln -s $target/thrift-$vers $target/thrift
