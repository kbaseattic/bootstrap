options(repos=c(CRAN="http://cran.r-project.org")) 
chooseCRANmirror(ind=87)
library(devtools)
with_libpaths(new = "/kb/runtime/lib/R/library/", install_github('cMonkeyNwInf','dreiss-isb',subdir='cMonkeyNwInf'));
