#!/bin/bash

dest=${TARGET-/kb/runtime}
if [[ $# -gt 1 ]] ; then
	dest=$1
	shift
fi

if [[ $# != 1 ]] ; then
    echo "Usage: $0 r-packages.R" 1>&2
    exit 1
fi

RLIB=$1
RURL="http://cran.r-project.org/src/base/R-3/"
RBASE="R-3.1.0"
TPAGE=`which tpage`

if [[ -x /usr/bin/apt-get ]] ; then
	echo "###### purge system R ######"
	apt-get -y remove --purge r-base-core

	echo "###### get R dependencies ######"
	apt-get --force-yes -y build-dep r-base
fi

echo "###### remove old R ######"
rm -rf $RBASE
rm -rf $dest/lib/R

echo "###### downloading $RBASE ######"
if [[ ! -s $RBASE".tar.gz" ]]; then
	curl -O -L $RURL$RBASE".tar.gz"
fi
tar zxf $RBASE".tar.gz"

echo "###### installing $RBASE ######"
pushd $RBASE
conf_opts="--enable-R-shlib --with-tcltk --prefix=$dest"

#
# On the mac we want a straight non-framework build
#
if [[ -d /Library ]] ; then
	conf_opts="$conf_opts --disable-R-framework"
fi

./configure $conf_opts

if [[ $? -ne 0 ]] ; then
	echo "configure failed" 1>&2
	exit 1
fi
	
make -j4
if [[ $? -ne 0 ]] ; then
	echo "make failed" 1>&2
	exit 1
fi
make install
if [[ $? -ne 0 ]] ; then
	echo "install failed" 1>&2
	exit 1
fi
popd
#rm $RBASE".tar.gz"
#rm -rf $RBASE

echo "###### installing R libraries ######"
echo "update.packages(checkBuilt=TRUE, ask=FALSE)" | $dest/bin/R --vanilla --slave
$TPAGE --define rlib=$dest/lib/R/library $RLIB | $dest/bin/R --vanilla --slave
