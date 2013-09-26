#!/bin/sh

#Thanks to Wei Tang for providing the basis for this script.
#This installs the requirements for running the MG-RAST pipeline in KBase
#D. Olson dolson@mcs.anl.gov

set -e
target=${TARGET-/kb/runtime}
INSTALLDIR=$target
#cd ${INSTALLDIR}

DATADIR=/mnt

#make directory for apps
mkdir -p ${INSTALLDIR}/apps

#install pipeline repo (for preprocess, dereplicate)
cd ${INSTALLDIR}/apps
if [ ! -d pipeline ]
then
    git clone https://github.com/MG-RAST/pipeline
else
    cd pipeline
    git pull origin master
fi

#install bowtie and download index file
#sudo apt-get -y install bowtie

#install some biotools: superblat, blat, usearch
if [ ! -d ${INSTALLDIR}/biotools ]
then 
    mkdir -p ${INSTALLDIR}/biotools
    cp superblat ${INSTALLDIR}/biotools/
    cp blat ${INSTALLDIR}/biotools/
    cp usearch ${INSTALLDIR}/biotools/
    chmod +x ${INSTALLDIR}/biotools/*
fi


#install qiime-uclust / qiime-dresee / qiime-blast
#in order to install only minimal set of tools from qiime, use a modified qiime_1.5.0_uclust.conf 
#in order to make qiime not break previous installed python lib, need to use a modified activate.sh
cd ${INSTALLDIR}/apps
if [ ! -d qiime ]
then
    mkdir -p ${INSTALLDIR}/apps/qiime
    wget --no-clobber -t 5 --retry-connrefused --waitretry 5 ftp://thebeast.colorado.edu/pub/QIIME-v1.5.0-dependencies/app-deploy-qiime-1.5.0.tgz
    tar zxvf app-deploy-qiime-1.5.0.tgz
    cd app-deploy-qiime-1.5.0/etc
    rm -f qiime_1.5.0_uclust.conf
    wget http://www.mcs.anl.gov/~wtang/files/qiime_1.5.0_uclust.conf
    cd ..
    python app-deploy.py ${INSTALLDIR}/apps/qiime -f etc/qiime_1.5.0_uclust.conf --force-remove-failed-dirs
    cd ${INSTALLDIR}/apps/qiime
    rm -f activate.sh
    wget http://www.mcs.anl.gov/~wtang/files/activate.sh
fi


#make links in ${INSTALLDIR}/apps/bin
mkdir -p ${INSTALLDIR}/apps/bin
cd ${INSTALLDIR}/apps/bin
ln -sf ${INSTALLDIR}/apps/pipeline/awecmd/awe_preprocess.pl 
ln -sf ${INSTALLDIR}/apps/pipeline/awecmd/awe_dereplicate.pl
ln -sf ${INSTALLDIR}/apps/pipeline/awecmd/awe_bowtie_screen.pl
ln -sf ${INSTALLDIR}/apps/pipeline/awecmd/awe_genecalling.pl
ln -sf ${INSTALLDIR}/apps/pipeline/awecmd/awe_cluster_parallel.pl
ln -sf ${INSTALLDIR}/apps/pipeline/awecmd/awe_blat.py
ln -sf ${INSTALLDIR}/apps/pipeline/awecmd/awe_annotate.pl
ln -sf ${INSTALLDIR}/apps/pipeline/awecmd/awe_rna_blat.sh
ln -sf ${INSTALLDIR}/apps/pipeline/awecmd/awe_rna_search.pl

#edit .bashrc for above apps

n=`grep 'FragGeneScan/1.16a/bin' ${INSTALLDIR}/.bashrc | wc -l`
if [ $n -eq 0 ]
then
    echo "PATH=\$PATH:${INSTALLDIR}/apps/FragGeneScan/1.16a/bin:${INSTALLDIR}/apps/pipeline/bin:${INSTALLDIR}/apps/pipeline/awecmd:${INSTALLDIR}/apps/biotools" >> ~/.bashrc
    echo "source ${INSTALLDIR}/apps/qiime/activate.sh" >> ~/.bashrc
fi

cd ~

echo "Install mgr apps ... Done!"
