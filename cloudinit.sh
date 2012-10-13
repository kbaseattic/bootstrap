#!/bin/bash

############################################
#   Master build script for kbase image    #	
#   Authors:                               #
#       Dan Olson                          #
#       Scott Devoid                       #
#       Jared Wilkening                    #
############################################

DIR="$( cd "$( dirname "$0" )" && pwd )"

# Add a private key that can read from the git repositories
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA4er0W6fIuEJIxYNBg0ExRJ9jpfNmq/AxWg4JY25tF5NuvjIc
9Yqve6+oDIGsQ0me9GLs4KRo75EiMK9Igj8LBlkO7xr2n/fUC0/VvSIq8ctpR/3R
XQKVczgugLAg718vmbS8yWGhH1T84Qnjvg249DU/t1jK112Uz4qV/rOg8KR60z6G
gY25uR1foCJ4bOQOA88iNAsP17sKy0QJ2nfJZi9GdbTOnTOh1kCDo7JtjQVlREC8
JU7rY/7gvJIPGUT8/XMaucI1HcMywgASkEAD5xN6VIbNfgkZwq385KHVL+DGG8qA
jZJMus3q9ob3u2tlenMlb9ug53rsZDMglJshCwIDAQABAoIBAE2FKcQplp5jYEUl
/NzlCdraNn9DPf/Rs52LI32S7qwgUufAml9G72AprihcdpfAM2L4bv/GapuJ2YmL
G/5VU5siBBXX0riheYlII7d6efHuMnoZhjW8JTwcExjlVufMabD8a6tObNMrfnpZ
wmP8oXJqsypetXuhCOcOTtnPGXJ42OR92uxSQ1Cn5cbECnmIGuH+bayOv43vLCSr
XI1FTY0+3rsfdIMla7w1q6IAmvih1a2SwCG1+zzpN7UfO9Vi+r4HpLtFf0RPjxiM
ROWcaWgWHglIdNoEvGYSVls7B1iHWgFqjxG+480ffAh5KhyTzYEfKwfHEsr+LpZ6
a6HtAYECgYEA+ZgB94dK8Bgl93mc8Tsvr2flPXTNOFXr7YO9EcqfTXwkrnQzyKgQ
69uxupJMsqnESYVUYWH7HowsddiqSUVK1S0auok29D469qkjDz1NK2xoPfKvl5l2
cAgp20MuVMfQIDdu0hU0o8KjxSD68S685UArIquIFB0rKSeWuH4biwkCgYEA57dh
W5bAps53Gx6rN6A8MmpygOZCtnxzSpbDswXl1t1sW8kPjZ+ZHZlHNKBUjVaWGL9I
XLc8hVHOW5v4s3hfm18Gp1+xeWhVeDPfgEByQ8zpRsVl8I9QBGczZGnKiTMq8EnC
UBJjyiogBpjs/I61fVkxMiK+KiMYMQPcxQWNTHMCgYEArYUqSOX8CTMgog4gN+1H
15BJZRJg4fuKDBP8S/QsD/hwoAAVSDjfmrmfs++l9sfjuKFC6njt1mzpM/yvVkUg
I1g6LtjaJa9l2rn3r86Uac3yIq8nuCNunbBvOQpZmYNYhC1FlDQ95mOY66FkFGzD
0jVsR6ws7J7itLfbJuQ1TdECgYATcjRdd11bomAkioJb/LqQkJZjcu+OWQtj6xsp
XwlW6uY5HbqMbCRxc3eiVwJBik62bPcpsMcHeUIUNha9GREM/QCV81X1lmf12oSb
Qs1UG1JIejB/68cPV4ncl3RD52NnHwmLpr9xK+/cHeFloKRijKWwS3IiHyfclTJl
5n1hOQKBgQCdBeNgt6LdU3CwKGYZKHYAqq65MX/fck/PuU/6MHiqmDK8PfDpyeU8
bVZZ2MQJY/Lo579YvI6gCCW4dOeALR/+UBD2/egHFakwRzR3GbfILjI06oxG/0rI
3Lpu/FYAacawlXKMykypjS6B/FP3zTsKDjNIT9bV5wgD+clYfYOAsg==
-----END RSA PRIVATE KEY-----" > ~root/.ssh/id_rsa
chmod 400 ~root/.ssh/id_rsa

# Add the authorized keys for git.kbase.us and the hacker's computer
echo "|1|4Qql1zSjbbZlcLI7xORqtq+ELUg=|lnGNVlEY9CkzRtrtChGRgnOvUQg= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2K6E4JMnvEXzmb2ArlVtKIon/TNow9aTYWQI9+EGzF79Pn2hkx3qJt/iJCRK66MhMkCdrWYPFY8IISfHeDFytQmN0+mOgK\
9famT6yUUXuL2MsfUVqtP7qrBghUEhnxw6jlKLrvdJawJ2+cmeN51bWIzo34khLOvDjHGT4ekVQR+aTQaY2pUcQFblXJs/swS8ysuPzwgEZNGLIz2bg1ssqki6mnbrFVl9G7+nKcsa7RQ1aTLPy1XduNU9+Giv2psCAgE9f7iplbcrM8z2kgycZu/qviw5G\
GKJxT3/gVHPtVcVjTX7RhdO9Kqubd0MBC33qy4RSISmIhd3koc4H1H7+w==
|1|JicCuAE/yoHjbl9c7a+r71DuKwE=|iTDwyEzKyKLItcdLU+Z8QSdCspE= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2K6E4JMnvEXzmb2ArlVtKIon/TNow9aTYWQI9+EGzF79Pn2hkx3qJt/iJCRK66MhMkCdrWYPFY8IISfHeDFytQmN0+mOgK\
9famT6yUUXuL2MsfUVqtP7qrBghUEhnxw6jlKLrvdJawJ2+cmeN51bWIzo34khLOvDjHGT4ekVQR+aTQaY2pUcQFblXJs/swS8ysuPzwgEZNGLIz2bg1ssqki6mnbrFVl9G7+nKcsa7RQ1aTLPy1XduNU9+Giv2psCAgE9f7iplbcrM8z2kgycZu/qviw5G\
GKJxT3/gVHPtVcVjTX7RhdO9Kqubd0MBC33qy4RSISmIhd3koc4H1H7+w==" >> ~root/.ssh/known_hosts

# change /etc/apt/sources.list to point to mirror.anl.gov
perl -i -pe "s/(us\.){0,1}archive\.ubuntu\.com/mirror\.anl\.gov/g" /etc/apt/sources.list
perl -i -pe 's/security\.ubuntu\.com/mirror\.anl\.gov/g' /etc/apt/sources.list
apt-get update

# install git-core, we need it to download bootstrap.git
apt-get install -y git-core

# clone this repository (it's not on the cloud instance)
git clone kbase@git.kbase.us:/bootstrap.git
pushd $(pwd)
pushd bootstrap

git pull
# run bootstrap script
./bootstrap.sh
popd
