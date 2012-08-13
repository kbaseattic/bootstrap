#!/bin/sh

export JAVA_HOME=/kb/runtime/java
export ANT_HOME=/kb/runtime/ant
export THRIFT_HOME=/kb/runtime/thrift
export PATH=${JAVA_HOME}/bin:${ANT_HOME}/bin:/kb/runtime/bin:${THRIFT_HOME}/bin:${PATH}

curl http://www.kbase.us/docs/build/jdk1.6.0_30.tar.gz > jdk1.6.0_30.tar.gz
tar zxvf jdk1.6.0_30.tar.gz -C /kb/runtime
ln -s /kb/runtime/jdk1.6.0_30 /kb/runtime/java

curl http://www.kbase.us/docs/build/apache-ant-1.8.4-bin.tar.gz > apache-ant-1.8.4-bin.tar.gz
tar zxvf apache-ant-1.8.4-bin.tar.gz -C /kb/runtime
ln -s /kb/runtime/apache-ant-1.8.4 /kb/runtime/ant

curl http://www.kbase.us/docs/build/apache-ivy-2.3.0-rc1-bin.tar.gz > apache-ivy-2.3.0-rc1-bin.tar.gz
tar zxvf apache-ivy-2.3.0-rc1-bin.tar.gz -C /kb/runtime
ln -s /kb/runtime/apache-ivy-2.3.0-rc1/ivy-2.3.0-rc1.jar /kb/runtime/ant/lib/.


