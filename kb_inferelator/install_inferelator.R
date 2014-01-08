#!Rscript
chooseCRANmirror(74);
install.packages('devtools', repos = "http://cran.cnr.berkeley.edu", dep=T);
library('devtools');
install_github('cMonkeyNwInf','dreiss-isb',subdir='cMonkeyNwInf');
