#!/bin/bash


pushd /usr/local
hg clone -u release https://code.google.com/p/go
pushd go
pushd src
./all.bash
popd
for B in `ls bin`; do
	if [ -e /usr/local/bin/$B ] ; then
		rm /usr/local/bin/$B
	fi
	ln -s `pwd`/bin/$B /usr/local/bin
done
popd
popd

export GOPATH=/usr/local/gopath
if [ ! -e $GOPATH ]; then
	mkdir $GOPATH
fi

for P in `cat ./golang-packages`; do
	go get -v $P
done


