#!/bin/bash
curl -O "http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.0.7.tgz"
tar -xzf mongodb-linux-x86_64-2.0.7.tgz
pushd `pwd`
cd mongodb-linux-x86_64-2.0.7
cp -r bin/* /kb/runtime/bin
popd

