#!/bin/bash

python=python
target=${TARGET-/kb/runtime}

if [[ $# -eq 1 ]] ; then
    pkg_list=$1
elif [[ $# -eq 2 ]] ; then
    pkg_list=$1
    target=$2
    python=$target/bin/python
else 
    echo "Usage: $0 python-qiime-list [target-runtime-dir]" 1>&2
    exit 1
fi

# python libs
while read TYPE PKG SRC VER; do
    echo "downloading $PKG via $TYPE"
    if [[ $TYPE == 'svn' ]]; then
        svn co $SRC $PKG
    elif [[ $TYPE == 'git' ]]; then
        git clone $SRC
        git checkout $VER
    fi
    if [[ ! -d $PKG ]] ; then
        echo "Download of $SRC did not create $PKG directory" 1>&2
        exit 2
    fi
    echo "installing $PKG"
    pushd $PKG
    $python setup.py install
    popd
done < $pkg_list

# set qiime
mkdir -p $target/qiime
mkdir -p $target/qiime/temp

# java rdp clasifier if java exists
if [ -d $target/java ]; then
    echo "installing rdp-classifier"
    wget -O rdp_classifier_2.2.zip http://sourceforge.net/projects/rdp-classifier/files/rdp-classifier/rdp_classifier_2.2.zip/download
    unzip -d $target/qiime/ rdp_classifier_2.2.zip
    ln -s $target/qiime/rdp_classifier_2.2/rdp_classifier-2.2.jar $target/lib/rdp_classifier.jar
    ln -s $target/qiime/rdp_classifier_2.2/rdp_classifier-2.2.jar $target/java/lib/rdp_classifier.jar
else
    echo "no java - skipping rdp-classifier"
fi

# greengenes data
#echo "installing greengenes libraries"
mkdir -p $target/qiime/greengenes
# removed, too big ! - leave path for module
#wget -O $target/qiime/greengenes/core_set_aligned.fasta.imputed http://greengenes.lbl.gov/Download/Sequence_Data/Fasta_data_files/core_set_aligned.fasta.imputed
#wget -O $target/qiime/greengenes/lanemask_in_1s_and_0s http://greengenes.lbl.gov/Download/Sequence_Data/lanemask_in_1s_and_0s
#wget ftp://greengenes.microbio.me/greengenes_release/gg_12_10/gg_12_10_otus.tar.gz
#tar -xzf gg_12_10_otus.tar.gz -C $target/qiime/greengenes

# pre-compiled 64-bit Linux
for B in bin/*; do 
    echo "install $B"
    cp $B $target/bin/.
done

# qiime config
touch $target/qiime/.qiime_config
echo -e "qiime_scripts_dir\t/usr/local/bin" >> $target/qiime/.qiime_config
echo -e "temp_dir\t$target/qiime/temp" >> $target/qiime/.qiime_config
echo -e "pynast_template_alignment_fp\t$target/qiime/greengenes/core_set_aligned.fasta.imputed" >> $target/qiime/.qiime_config
echo -e "template_alignment_lanemask_fp\t$target/qiime/greengenes/lanemask_in_1s_and_0s" >> $target/qiime/.qiime_config
