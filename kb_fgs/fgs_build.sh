#!/bin/sh
set -x

. ../tools/error_handler

trap 'error ${LINENO}' ERR

target=${TARGET-/kb/runtime}

if [[ $# -gt 0 ]] ; then
	target=$1
	shift
fi


vers=1.16
url=http://omics.informatics.indiana.edu/mg/get.php?justdoit=yes&software=FragGeneScan${vers}.tar.gz

tar=FragGeneScan$vers.tar.gz

curl -o $tar -L $url

rm -rf $target/FragGeneScan$vers
tar -C $target/FragGeneScan$vers -zxf $tar

rm -f $target/fgs
ln -s $target/FragGeneScan$vers $target/fgs
