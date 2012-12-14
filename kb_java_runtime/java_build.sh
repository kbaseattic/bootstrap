#!/bin/sh

export JAVA_HOME=/kb/runtime/java
export ANT_HOME=/kb/runtime/ant
export THRIFT_HOME=/kb/runtime/thrift
export CATALINA_HOME=/kb/runtime/tomcat
export PATH=${JAVA_HOME}/bin:${ANT_HOME}/bin:/kb/runtime/bin:${THRIFT_HOME}/bin:${CATALINA_HOME}/bin:${PATH}

curl http://www.kbase.us/docs/build/jdk1.6.0_30.tar.gz > jdk1.6.0_30.tar.gz
#cleanup old
rm -rf /kb/runtime/jdk1.6*
rm /kb/runtime/java
#install new 
tar zxvf jdk1.6.0_30.tar.gz -C /kb/runtime
ln -s /kb/runtime/jdk1.6.0_30 /kb/runtime/java

curl http://www.kbase.us/docs/build/apache-ant-1.8.4-bin.tar.gz > apache-ant-1.8.4-bin.tar.gz
rm -rf /kb/runtime/apache-ant*
rm /kb/runtime/ant
tar zxvf apache-ant-1.8.4-bin.tar.gz -C /kb/runtime
ln -s /kb/runtime/apache-ant-1.8.4 /kb/runtime/ant

curl http://www.kbase.us/docs/build/apache-ivy-2.3.0-rc1-bin.tar.gz > apache-ivy-2.3.0-rc1-bin.tar.gz
rm -rf /kb/runtime/apache-ivy*
tar zxvf apache-ivy-2.3.0-rc1-bin.tar.gz -C /kb/runtime
ln -s /kb/runtime/apache-ivy-2.3.0-rc1/ivy-2.3.0-rc1.jar /kb/runtime/ant/lib/.

curl http://kbase.us/docs/build/apache-tomcat-7.0.32.tar.gz > apache-tomcat-7.0.32.tar.gz
rm -rf /kb/runtime/tomcat*
tar zxvf apache-tomcat-7.0.32.tar.gz -C /kb/runtime
ln -s /kb/runtime/apache-tomcat-7.0.32 /kb/runtime/tomcat

#
# Standard java libraries.
#

jackson=jackson-all-1.9.11.jar

curl -o /kb/runtime/lib/$jackson http://jackson.codehaus.org/1.9.11/$jackson
ln -s /kb/runtime/lib/$jackson /kb/runtime/lib/jackson-all.jar