#!/bin/sh

for P in `cat ./python-pip-list`; do
	echo "pip installing $P"
	pip install $P
done