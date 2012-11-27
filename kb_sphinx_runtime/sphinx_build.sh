#!/bin/sh

wget http://sphinxsearch.com/files/sphinx-2.0.6-release.tar.gz
tar -zxvf sphinx-2.0.6-release.tar.gz 
cd sphinx-2.0.6-release
make && make install
