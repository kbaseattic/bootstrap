#!/bin/bash
if [ $# -eq 0 ] ; then
	echo "Usage: $0 target" 1>&2
	exit 1
fi
target=$1
curl http://cloud.github.com/downloads/SiteSupport/gevent/gevent-1.0rc2.tar.gz > gevent-1.0rc2.tar.gz
tar -xvf gevent-1.0rc2.tar.gz 
cd gevent-1.0rc2
python setup.py install
