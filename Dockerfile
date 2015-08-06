# Dockerfile that builds a minimal runtime
#
#
# Copyright 2015 The Regents of the University of California,
# Lawrence Berkeley National Laboratory
# United States Department of Energy
# The DOE Systems Biology Knowledgebase (KBase)
# Made available under the KBase Open Source License
#
FROM ubuntu:14.04
MAINTAINER Shane Canon scanon@lbl.gov

RUN DEBIAN_FRONTEND=noninteractive apt-get update;apt-get -y upgrade;apt-get install -y \
	mercurial bzr gfortran subversion tcsh cvs mysql-client libgd2-dev tcl-dev tk-dev \
	libtiff-dev libpng12-dev libpng-dev libjpeg-dev libgd2-xpm-dev libxml2-dev \
	libwxgtk2.8-dev libdb5.1-dev libgsl0-dev libxslt1-dev libfreetype6-dev libreadline-dev \
	libpango1.0-dev libx11-dev libxt-dev libcairo2-dev zlib1g-dev libgtk2.0-dev python-dev \
	libmysqlclient-dev libmysqld-dev libssl-dev libpq-dev libexpat1-dev libzmq-dev libbz2-dev \
	libncurses5-dev libcurl4-gnutls-dev uuid-dev git wget uuid-dev build-essential curl \
	libsqlite3-dev libffi-dev

RUN mkdir /kb
ENV TARGET /kb/runtime
ENV PATH ${TARGET}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN mkdir /kb;mkdir /kb/runtime;mkdir /kb/runtime/bin

# Install Java.
RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  rm -rf /var/cache/oracle-jdk7-installer

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle/

# Install R
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y r-base-dev

# Add r packages
ADD ./kb_r_runtime/r-packages.R /tmp/r-packages.R

# Fix up rlib and install r packages
RUN mkdir -p /kb/runtime/lib/R/library && cat /tmp/r-packages.R|sed 's/\[\% rlib \%\]/\/kb\/runtime\/lib\/R\/library/' | R --vanilla --slave

# Install python packages
RUN \
   apt-get install -y python-pip python-requests python-simplejson python-openssl \
       python-pyasn1 python-numpy python-paramiko python-django  python-scipy python-qcli \
       python-pymongo python-jinja2 python-biopython python-nose python-lxml \
       python-jsonschema python-poster python-rsa python-appdirs cython python-pygments \
       python-virtualenv python-configobj python-dateutil python-oauth2 python-setuptools \
       python-SQLAlchemy python-mpi4py  python-matplotlib python-sphinx python-zmq \
       python-beautifulsoup python-tornado python-rpy2 python-pika python-pexpect \
       uwsgi-plugin-python  python-django-nose python-django-piston python-flup \
       python-networkx python-markdown  python-jsonrpclib python-scikits-learn

# Install perl packages
RUN \
   apt-get install -y  libxml-perl golang golang-goprotobuf-dev bioperl libfile-touch-perl \
       libcgi-fast-perl libfcgi-perl libjson-rpc-perl libuuid-perl  libcairo-perl libmoosex-yaml-perl \
       libmongodb-perl libmoosex-nonmoose-perl libmoosex-singleton-perl libjson-perl \
       libcarp-assert-perl libgraph-perl libmoosex-method-signatures-perl libmath-random-mt-perl \
       libmath-sparsematrix-perl libtext-simpletable-perl libcache-memcached-fast-perl \
       libcache-memcached-perl libcrypt-openssl-rsa-perl libdancer-logger-psgi-perl liblog-log4perl-perl \
       libjson-any-perl libtemplate-perl  libtest-cmd-perl libtest-json-perl  libparse-yapp-perl \
       libplack-middleware-crossorigin-perl starman  libconfig-tiny-perl libcoro-twiggy-perl \
       libtext-table-perl libtaint-util-perl libstring-camelcase-perl libapp-cmd-perl \
       libio-prompt-tiny-perl libipc-system-simple-perl libhtml-strip-perl libcarp-always-perl \
       libnet-oauth-perl libconvert-pem-perl liburi-perl libdbi-perl libgetopt-declare-perl \
       libio-interactive-perl libsphinx-search-perl libdigest-sha-perl libterm-readline-perl-perl \
       libcrypt-openssl-x509-perl libipc-shareable-perl libconfig-simple-perl libdigest-sha-perl \
       libterm-readline-gnu-perl libdata-dumper-simple-perl libdata-stag-perl \
       libdata-structure-util-perl libfile-nfslock-perl libfile-slurp-unicode-perl libfile-touch-perl \
       libfile-copy-recursive-perl libmoosex-params-validate-perl  libstring-random-perl \
       libpdl-stats-perl libmodule-util-perl  libdevel-size-perl libemail-valid-perl libhtml-template-perl \
       libnumber-format-perl libapache-htpasswd-perl libcgi-psgi-perl libxml-dumper-perl libfile-homedir-perl \
       libspreadsheet-xlsx-perl libmime-tools-perl libsoap-lite-perl liblingua-en-inflect-perl libexception-class-perl \
       libclass-autouse-perl libcontextual-return-perl libterm-readline-gnu-perl cpanminus

RUN ln -s /usr/bin/java /usr/bin/javac /usr/bin/python /usr/bin/pip /usr/bin/perl /usr/bin/cpan \
       /usr/bin/tpage /usr/bin/pod2html /usr/bin/starman /kb/runtime/bin

# Wrapper for pod2man so it doesn't stop the build
RUN echo '#!/bin/sh' > /kb/runtime/bin/pod2man && \
    echo '/usr/bin/pod2man $@ || exit 0' >> /kb/runtime/bin/pod2man && \
    chmod 755 /kb/runtime/bin/pod2man

ADD . /kb/bootstrap
WORKDIR /kb/bootstrap
RUN cd kb_java_runtime;  ./java_build.sh -u && \
  rm -rf /kb/bootstrap/kb_j*

RUN cd kb_daemonize;./install-daemonize.sh
RUN \
  cpanm -i Digest::SHA1 && \ 
  cpanm -i Object::Tiny::RW --notest && \
  cpanm -i RPC::Any::Server::JSONRPC::PSGI --notest && \
  cpanm -i JSON::RPC::Client && \
  pip install uwsgi && \
  pip install jsonrpcbase && \
  apt-get install -y python-yaml && \
  pip install  requests --upgrade

RUN \
  rm -rf /var/lib/apt/lists/* 
