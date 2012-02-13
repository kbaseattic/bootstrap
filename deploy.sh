#!/bin/sh
git clone kbase@git.kbase.us:dev.git
cd dev/modules
for i in `cat repos.list`; do 
  git clone kbase@git.kbase.us:${i}
done
