#!/bin/bash
curl http://cloud.github.com/downloads/SiteSupport/gevent/gevent-1.0rc2.tar.gz > gevent-1.0rc2.tar.gz
tar -xvf gevent-1.0rc2.tar.gz 
pushd gevent-1.0rc2/
python setup.py install
popd
