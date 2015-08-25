#!/bin/bash

if [ $# -gt 0 ] ; then
	DIR=$1
else
	DIR=${TARGET-/kb/runtime}
fi

wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz
tar -xzf go1.4.2.linux-amd64.tar.gz -C /usr/local/
ln -s /usr/local/go/bin/* $TARGET/bin/
export GOPATH=${DIR}/gopath
if [ ! -e $GOPATH ]; then
	mkdir $GOPATH
fi

for P in `cat ./golang-packages`; do
	go get -v $P
done


