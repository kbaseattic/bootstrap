#!/bin/bash

DIR=$1 
: ${DIR:="/kb/runtime"}

gopath=${DIR}/gopath
export GOPATH=${gopath}

pushd ${DIR}
mkdir -p awe/conf awe/data awe/work awe/bin awe/logs
popd

if [ ! -e $GOPATH ]; then
	mkdir $GOPATH
fi

echo "[Anonymous]
# Controls weither an anonymous user can read/write
# values: true/false
read=true
write=true
create-user=true

[Ports]
# Ports for site/api
# Note: use of port 80 may require root access
site-port=8081
api-port=8001

[External]
site-url=
api-url=

[Admin]
email=admin@host.com
secretkey=supersecretkey

[Directories]
# See documentation for details of deploying Shock
site=${DIR}/awe/site
data=${DIR}/awe/data
logs=${DIR}/awe/logs

[Mongodb]
# Mongodb configuration:
# Hostnames and ports hosts=host1[,host2:port,...,hostN]
hosts=localhost

[Mongodb-Node-Indices]
# See http://www.mongodb.org/display/DOCS/Indexes#Indexes-CreationOptions for more info on mongodb index options.
# key=unique:true/false[,dropDups:true/false][,sparse:true/false]
id=unique:true

[Server]
perf_log_workunit=true

[Client]
totalworker=2
workpath=${DIR}/awe/work
app_path=/home/ubuntu/apps/bin
serverurl=http://localhost:8001
name=default_client
group=default_group
auto_clean_dir=false
worker_overlap=false
print_app_msg=false" > ./awe.cfg

go get -v github.com/MG-RAST/AWE/...
cp -v ${gopath}/bin/awe-server ${DIR}/awe/bin
cp -v ${gopath}/bin/awe-client ${DIR}/bin
cp -v -r ${gopath}/src/github.com/MG-RAST/AWE/site ${DIR}/awe
cp -v ./awe.cfg ${DIR}/awe/conf



