#!/bin/sh
# compatible with kbase-image-v8

# git cloning
cd /kb
git clone ssh://kbase@git.kbase.us/dev_container
cd dev_container/modules

##
git clone ssh://kbase@git.kbase.us/communities_api
git clone ssh://kbase@git.kbase.us/idserver

# deploy
cd /kb/dev_container
make deploy

# start services 
exec /kb/deployment/services/communitiesServer/start_service


