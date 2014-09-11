#!/usr/bin/env bash

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


git clone git://github.com/pezmaster31/bamtools.git
pushd bamtools
mkdir build
pushd build
cmake ..
make
popd

mkdir -p $target/bin/
mkdir -p $target/lib/
mkdir -p $target/include/

cp -r ./bin/* $target/bin/
cp -r ./lib/* $target/lib/
cp -r ./include/* $target/include/
