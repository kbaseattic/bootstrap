#!/bin/bash

if [ $# -gt 0 ] ; then
	DIR=$1
else
	DIR=${TARGET-/kb/runtime}
fi

pushd ${DIR}
hg clone -u release https://code.google.com/p/go
pushd go
pushd src
./all.bash
popd
for B in `ls bin`; do
	if [ -e ${DIR}/bin/$B ] ; then
		rm ${DIR}/bin/$B
	fi
	ln -s `pwd`/bin/$B ${DIR}/bin
done
popd
popd

export GOPATH=${DIR}/gopath
if [ ! -e $GOPATH ]; then
	mkdir $GOPATH
fi

for P in `cat ./golang-packages`; do
	go get -v $P
done


