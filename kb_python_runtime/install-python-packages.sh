#!/bin/sh

function error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}

trap 'error ${LINENO}' ERR

target=${TARGET-/kb/runtime}

if [ $# -gt 0 ] ; then
	target=$1
	shift
fi

if [ -x $target/bin/python ] ; then
    python=$target/bin/python
else
    python=python
fi

#curl -L -k http://python-distribute.org/distribute_setup.py | $python

curl -k -L https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py | $python

curl -k -L https://raw.github.com/pypa/pip/master/contrib/get-pip.py | $python

if [ -x $target/bin/pip ] ; then
	pip="$target/bin/pip"
else
	pip="pip"
fi

if [ -x $target/bin/easy_install ] ; then
	easy_install="$target/bin/easy_install"
else
	easy_install="easy_install"
fi

for P in `cat ./python-pip-list`; do
	echo "$pip installing $P"
	$pip install $P --upgrade
done

for P in `cat ./python-easy-list`; do
	echo "easy_installing $P"
	$easy_install $P
done

if [ -d "/usr/local/lib/python2.7/dist-packages" ] ; then
	rm -rf /usr/local/lib/python2.7/dist-packages/django_piston-0.2.3-py2.7*
fi

chmod a+x install-gevent.sh
./install-gevent.sh $target

chmod a+x install-nexus.sh
./install-nexus.sh $target
