#!/bin/bash

function if_error() {
  EXIT_CODE=$1
  MESSAGE=$2*
  if [ $EXIT_CODE != 0 ]
  then
    echo "$(basename $0) failed with exit code $EXIT_CODE and message $MESSAGE at $(date)"
  fi
}

while [ -z $target ]
do
  echo -n "target not defined, please enter location to install runtime:"
  read target
  export $target
done

cp VERSION ${target}/

# install debian dependencies
pushd kb_bootstrap
./install-debian-packages package-list.ubuntu
if_error $? "install-debian-packages"
popd

# install node and npm
pushd kb_node_runtime
./build.node
if_error $? "build.node"
popd

# build and install perl 
pushd kb_perl_runtime
./build.runtime
if_error $? "build.runtime"
popd

# build and install golang
pushd kb_golang_runtime
./install-golang.sh
if_error $? "install-golang.sh"
popd

# build and install shock
pushd kb_shock
./install-shock.sh
if_error $? "install-shock.sh"
popd

# build and install R base and libraries
pushd kb_r_runtime
./install-r.sh r-packages.R
if_error $? "install-r.sh"
popd

# build and install python modules
pushd kb_python_runtime
./install-python-packages.sh
if_error $? "install-python-packages.sh"
popd

# build and install qiime python modules
pushd kb_qiime
./install-qiime.sh python-qiime-list
if_error $? "install-qiime"
popd

# build and install oracle java
pushd kb_java_runtime
./java_build.sh
if_error $? "java_build.sh"
popd

# build and install thrift
pushd kb_thrift_runtime
./thrift_build.sh
if_error $? "thrift-build.sh"
popd

# install mongodb 2.2 binary
pushd kb_mongodb
./install-mongodb.sh
if_error $? "install-mongodb.sh"
popd

# install jellyfish
pushd kb_jellyfish
./jellyfish_build.sh
if_error $? "jellyfish_build.sh"
popd

# install jellyfish
pushd kb_cdbfasta
./cdbfasta_build.sh
if_error $? "cdbfasta_build.sh"
popd

#
# Some builds using a common model.
#

builds="seed_kmers prodigal glimmer elph"
for build in $builds; do
	pushd kb_$build
	./build.$build
	if_error $? "build.$build"
	popd
done
