#!/bin/bash

pushd /usr/local
hg clone -u release https://code.google.com/p/go
pushd go
pushd src
./all.bash
popd
for B in `ls bin`; do
	ln -s `pwd`/bin/$B /usr/local/bin
done
popd

export GOPATH=/usr/local/gopath
mkdir $GOPATH

for P in `cat golang-packages`; do
	go get -v $P
done


