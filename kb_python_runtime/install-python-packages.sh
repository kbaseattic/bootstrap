#!/bin/sh

for P in `cat ./python-pip-list`; do
	echo "pip installing $P"
	pip install $P --upgrade
done

for P in `cat ./python-easy-list`; do
	echo "easy_installing $P"
	easy_install $P
done
