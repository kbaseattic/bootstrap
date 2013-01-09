#!/bin/sh

target=/kb/runtime

if [ $# -gt 0 ] ; then
	target=$1
	shift
fi

if [ -x $target/bin/pip ] ; then
	pip="$target/bin/pip"
else
	pip="pip"
fi

for P in `cat ./python-pip-list`; do
	echo "$pip installing $P"
	$pip install $P --upgrade
done

for P in `cat ./python-easy-list`; do
	echo "easy_installing $P"
	easy_install $P
done

if [ -d "/usr/local/lib/python2.7/dist-packages" ] ; then
	rm -rf /usr/local/lib/python2.7/dist-packages/django_piston-0.2.3-py2.7*
fi

chmod a+x install-gevent.sh
./install-gevent.sh

chmod a+x install-nexus.sh
./install-nexus.sh
