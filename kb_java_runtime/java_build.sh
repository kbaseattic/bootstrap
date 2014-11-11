#!/bin/sh

# usage: 
#   build_java.sh
#   build_java.sh /kb/runtime
#   build_java.sh -u /kb/runtime
#
# general form:
#  build_java.sh -u <target>
#
# -u 		is optional, it will over-ride java restricted
# <target> 	is optional, it will default to /kb/runtime
restricted="restricted"
while getopts u opt; do
  case $opt in
    u)
      echo "-u was triggered, overridding restricted"
      shift
      restricted="unrestricted"
      ;;
    \?)
      echo "invalid option: -$OPTARG"
      ;;
  esac
done


target=${TARGET-/kb/runtime}
if [ $# -ne 0 ] ; then
	target=$1
	shift
fi
echo "using $target as runtime"

export JAVA_HOME=$target/java
export ANT_HOME=$target/ant
export THRIFT_HOME=$target/thrift
export CATALINA_HOME=$target/tomcat
export GLASSFISH_HOME=$target/glassfish3
export PATH=${JAVA_HOME}/bin:${ANT_HOME}/bin:$target/bin:${THRIFT_HOME}/bin:${CATALINA_HOME}/bin:${PATH}

mkdir -p $target/lib

#
# We don't install this version on the mac; we use the one that
# came with the system.
#
if [ -d /Library/Java/Home ] ; then
	export JAVA_HOME=/Library/Java/Home
elif [ -x /usr/libexec/java_home ] ; then
	export JAVA_HOME=`/usr/libexec/java_home`
else
	echo "Install JDK, restricted set to $restricted"
	if [ "$restricted" = unrestricted ] ;
	then
	  #cleanup old
	  rm -rf $target/jdk1.6*
	  rm -rf $target/jdk1.7*
	  rm $target/java
	  find /$target/bin -xtype l -delete
	  #install new 
	  tar zxvf jdk-7u45-linux-x64.tar.gz -C $target
	  ln -s $target/jdk1.7.0_45 $target/java
	  ln -s $target/jdk1.7.0_45/bin/* $target/bin/
	else
	  echo "This component is restricted, please download the tarball from the rights holder."
	fi
	export JAVA_HOME=$target/java
fi

echo "Install Ant"
v=1.9.4
curl -O http://apache.cs.utah.edu//ant/binaries/apache-ant-$v-bin.tar.gz

rm -rf $target/apache-ant*
rm $target/ant
tar zxvf apache-ant-$v-bin.tar.gz -C $target
if [ $? -ne 0 ] ; then
	echo "Failed to unpack ant" 1>&2
	exit 1
fi
ln -s $target/apache-ant-$v $target/ant
ln -s $target/ant/bin/ant $target/bin/ant

echo "Install Ivy"
curl -O http://apache.cs.utah.edu//ant/ivy/2.3.0/apache-ivy-2.3.0-bin.tar.gz
rm -rf $target/apache-ivy*
tar zxvf apache-ivy-2.3.0-bin.tar.gz -C $target
if [ $? -ne 0 ] ; then
	echo "Failed to unpack ivy" 1>&2
	exit 1
fi
ln -s $target/apache-ivy-2.3.0/ivy-2.3.0.jar $target/ant/lib/.

echo "Install tomcat"
v=7.0.57
curl -O "ftp://apache.cs.utah.edu/apache.org/tomcat/tomcat-7/v$v/bin/apache-tomcat-$v.tar.gz"
rm -rf $target/tomcat*
tar zxvf apache-tomcat-$v.tar.gz -C $target
if [ $? -ne 0 ] ; then
	echo "Failed to unpack tomcat" 1>&2
	exit 1
fi
ln -s $target/apache-tomcat-$v $target/tomcat

#
# Standard java libraries.
#

echo "Install glassfish"
curl -O http://dlc.sun.com.edgesuite.net/glassfish/3.1.2.2/release/glassfish-3.1.2.2-ml.zip
rm -rf $target/glassfish*
unzip -d $target/ glassfish-3.1.2.2-ml.zip 
if [ $? -ne 0 ] ; then
	echo "Failed to unpack glassfish" 1>&2
	exit 1
fi

jackson=jackson-all-1.9.11.jar

echo "Install jackson"
rm -rf $target/lib/jackson-all*
curl -o $target/lib/$jackson http://jackson.codehaus.org/1.9.11/$jackson
ln -s $target/lib/$jackson $target/lib/jackson-all.jar

mkdir -p $target/env
echo "
if [ -d /Library/Java/Home ] ; then
	export JAVA_HOME=/Library/Java/Home
elif [ -x /usr/libexec/java_home ] ; then
	export JAVA_HOME=\`/usr/libexec/java_home\`
else
	export JAVA_HOME=$target/java
fi
export ANT_HOME=$target/ant
export THRIFT_HOME=$target/thrift
export CATALINA_HOME=$target/tomcat
export GLASSFISH_HOME=$target/glassfish3
export PATH=\${JAVA_HOME}/bin:\${ANT_HOME}/bin:$target/bin:\${THRIFT_HOME}/bin:\${CATALINA_HOME}/bin:\${PATH}" > $target/env/java-build-runtime.env

