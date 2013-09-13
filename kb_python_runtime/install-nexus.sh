#!/bin/bash

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

if [ $# -eq 0 ] ; then
        echo "Usage: $0 target" 1>&2
        exit 1
fi
target=$1

git clone http://github.com/globusonline/python-nexus-client.git
cd python-nexus-client
git pull
python setup.py install
