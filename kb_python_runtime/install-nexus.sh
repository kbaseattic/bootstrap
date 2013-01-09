#!/bin/bash
git clone http://github.com/globusonline/python-nexus-client.git
pushd python-nexus-client/
git pull
python setup.py install
popd
