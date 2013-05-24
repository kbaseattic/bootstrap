#!/bin/bash

DIR=$1 
: ${DIR:="/kb/runtime"}

gopath=${DIR}/gopath
export GOPATH=${gopath}

pushd ${DIR}
mkdir -p shock/conf shock/bin shock/logs /shock/data
popd

if [ ! -e $GOPATH ]; then
	mkdir $GOPATH
fi

echo "[Anonymous]
# Controls an anonymous user's ability to read/write
# values: true/false
read=true
write=false
create-user=false

[Ports]
# Ports for site/api
# Note: use of port 80 may require root access
site-port=7444
api-port=7445

[External]
site-url=http://localhost

[Auth]
# defaults to local user management with basis auth
#type=basic
# comment line about and uncomment below to use Globus Online as auth provider
type=globus 
globus_token_url=https://nexus.api.globusonline.org/goauth/token?grant_type=client_credentials
globus_profile_url=https://nexus.api.globusonline.org/users

[Admin]
email=admin@host.com
secretkey=supersecretkey

[Directories]
# See documentation for details of deploying Shock
site=${DIR}/shock/site
data=${DIR}/shock/data
logs=${DIR}/shock/logs
local_paths=disabled

[Mongodb]
# Mongodb configuration:
# Hostnames and ports hosts=host1[,host2:port,...,hostN]
hosts=localhost

[Mongodb-Node-Indices]
# See http://www.mongodb.org/display/DOCS/Indexes#Indexes-CreationOptions for more info on mongodb index options.
# key=unique:true/false[,dropDups:true/false][,sparse:true/false]
id=unique:true

[SSL]
enable=false
key=
cert=" > ./shock.cfg

go get -v github.com/MG-RAST/Shock/...
cp -v ${gopath}/bin/shock-server ${DIR}/shock/bin
cp -v ${gopath}/bin/shock-client ${DIR}/bin
cp -v -r ${gopath}/src/github.com/MG-RAST/Shock/shock-server/site ${DIR}/shock
cp -v ./shock.cfg ${DIR}/shock/conf
cp -v ./README ${DIR}/shock/



