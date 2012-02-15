#!/bin/sh
# compatible with kbase-image-v8

# install nodejs
apt-get update
apt-get install libssl libpq-dev

mkdir /kb/build
cd /kb/build
curl http://nodejs.org/dist/v0.6.10/node-v0.6.10.tar.gz | tar xfz - 
cd node-v0.6.10
./configure
make install
alias node=`which node`

# install npm
curl http://npmjs.org/install.sh | sh

# git cloning
cd /kb
git clone ssh://kbase@git.kbase.us/dev_container
cd dev_container/modules

##
git clone ssh://kbase@git.kbase.us/shock
cd shock
export PGPASSWORD=dontTell22
./bootstrap.sh -d /mnt -p 8000 -N shock -H db1.chicago.kbase.us -U shockadmin -P dontTell22

# deploy
cd /kb/dev_container
make deploy

# start services 
exec /kb/deployment/services/shock/start_service


