#!/bin/bash

if [ $# -eq 0 ] ; then
        echo "Usage: $0 target" 1>&2
        exit 1
fi
target=$1

git clone http://github.com/globusonline/python-nexus-client.git
cd python-nexus-client
git pull
$target/bin/python setup.py install
