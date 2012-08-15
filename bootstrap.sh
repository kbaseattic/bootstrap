#!/bin/bash

# install debian dependencies
pushd kb_bootstrap
./install-debian-packages package-list.ubuntu
popd

# install node and npm
pushd kb_node_runtime
./build.node
popd

# build and install perl 
pushd kb_perl_runtime
./build.runtime
popd

# build and install golang
pushd kb_golang_runtime
./install-golang.sh
popd

# build and install R base and libraries
pushd kb_r_runtime
./install-r.sh r-packages.R
popd

# build and install python modules
pushd kb_python_runtime
./install-python-packages.sh
popd

# build and install qiime python modules
pushd kb_qiime
./install-qiime.sh python-qiime-list
popd

# build and install oracle java
pushd kb_java_runtime
./java_build.sh
popd

# build and install thrift
pushd kb_thrift_runtime
./thrift_build.sh
popd

# install mongodb 2.2 binary
pushd kb_mongodb
./install-mongodb.sh
popd


