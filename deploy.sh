#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd )"
git clone kbase@git.kbase.us:dev_container.git
pushd $DIR/dev_container/modules
for i in `cat $DIR/repos.list`; do 
  git clone kbase@git.kbase.us:${i}
done
popd

