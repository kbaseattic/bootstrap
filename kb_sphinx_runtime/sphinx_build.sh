#!/bin/sh

target=${TARGET-/kb/runtime}

if [ $# -gt 0 ] ; then
	target=$1
	shift
fi

configure_flags="--prefix $target"

if [ -d /Library ] ; then
	#
	# On the mac don't build with mysql; this is too dependent on
	# machine setup and availibility of 32/64 bit versions of libs etc.
	#
	configure_flags="$configure_flags --without-mysql"
fi

curl -O http://sphinxsearch.com/files/sphinx-2.0.6-release.tar.gz
tar -zxvf sphinx-2.0.6-release.tar.gz 
cd sphinx-2.0.6-release
./configure $configure_flags
make && make install
