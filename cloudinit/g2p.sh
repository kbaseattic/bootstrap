#!/bin/sh
# compatible with kbase-image-v6

cd /kb 

# v6 oddness
chmod +x /kb/runtime/cpanm
/kb/runtime/cpanm -i -f Template::Tools::tpage Starman RPC::Any::Server::JSONRPC::PSGI
mkdir /kb/runtime/bin
cp `which tpage` `which starman` /kb/runtime/bin/

# git cloning
git clone ssh://kbase@git.kbase.us/dev_container
cd dev_container/modules

##
git clone ssh://kbase@git.kbase.us/idserver
git clone ssh://kbase@git.kbase.us/gwas_db

# deploy
cd /kb/dev_container
make deploy

# start services 
exec /kb/deployment/services/g2p/start_service


