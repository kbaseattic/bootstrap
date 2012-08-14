KBase Bootstrap Repository
==========================

This repository adds 3rd party dependencies to an Ubuntu image.
This includes specific versions of various programming languages
and associated libraries.

Structure
---------

* cloudinit.sh
* bootstrap.sh
* deploy.sh
* repos.list
* *subdirectories*

### bootstrap.sh ###

This script does the primary work of adding 3rd party dependencies
to the Ubuntu image. First, we add the Aptitude packages listed in
`kb_bootstrap/package-list.ubuntu` using the `install-debian-packages`
command.

Next we install several languages and libraries that are not easy
to install properly using Aptitude:

* `kb_golang_runtime`: Install the Go programming language
* `kb_hadoop_setup`: Setup Hadoop dependencies
* `kb_java_runtime`: Install the Java programming language
* `kb_node_runtime`: Install the Node programming language
* `kb_perl_runtime`: Install the Perl programming language
* `kb_python_runtime`: Install the Python programming language
* `kb_qiime`: Install Quantitative Insights Into Microbial Ecology
   (QIIME) software package
* `kb_thrift_runtime`: Install Apache Thrift RPC language interface
   definition
