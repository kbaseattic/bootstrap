#!/bin/sh
# compatible with kbase-image-v6

cd /kb 
# tar xzfp ~olson/runtime.tgz

# git cloning
git clone ssh://kbase@git.kbase.us/dev_container
cd dev_container/modules

##
git clone ssh://kbase@git.kbase.us/gwas_db

# deploy
cd /kb/dev_container
make deploy

# start services 
#exec /kb/deployment/services/idserver/start_service &


