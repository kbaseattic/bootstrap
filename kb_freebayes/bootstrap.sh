#!/usr/bin/env bash

# set up for freebayes 

# build script for bamtools

target=${TARGET-/usr/local}

if [[ $# -ne 0 ]] ; then
        target=$1
        shift
fi


apt-get update
apt-get install -y build-essential
apt-get install -y git
apt-get install -y cmake
apt-get install -y libncurses5-dev
apt-get install -y libncurses5
apt-get install -y dh-autoreconf
apt-get install -y pkg-config

git clone --recursive git://github.com/ekg/freebayes.git

pushd freebayes
make
# make install
mkdir -p $target/bin
cp bin/freebayes bin/bamleftalign $target/bin/
popd
