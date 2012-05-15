#!/usr/bin/env python

import sys
import os
from fabric.api import run,env,cd,sudo,roles
from fabric.operations import put
from fabric.contrib.files import exists as fabric_exists
import json
from lxml import etree

#######
###Setup
#######

CONFFILE = "setup.json"
with open(CONFFILE) as fh:
    try:
        conf = json.load(fh)
    except Exception as e:
        print e
        print "error loading %s" % CONFFILE
        sys.exit()

#read in role information
username = conf['hosts']['username']
myroles = {'slave':[],'namenode':[username+"@"+conf['hosts']['namenode']]}
if not conf['hosts']['jobtracker'] == None:
    myroles['jobtracker'] = [username+"@"+conf['hosts']['jobtracker']]
else:
    myroles['jobtracker'] = roles['namenode']

if(not conf['hosts']['datanodes']):
    with open(conf['hosts']['datanodes_file']) as fh:
        dnodelist = []
        for line in fh:
            if line.startswith("#"):
                continue
            dnodelist.append(username+"@"+line.strip())
        myroles['slave'] = dnodelist
else:
    myroles['slave'] = [username+"@"+slave for slave in conf['hosts']['datanodes']]  

env.roledefs = myroles

def runCmd(cmd):
    if conf['hosts']['use_sudo']:
        sudo(cmd)
    else:
        run(cmd)

#############
####SSH tasks 
####To run a specific task:
#### $>fab task
####If function is generic:
#### $>fab -R role task
####
###Ex. $> fab -R slave hostname
####
#############

@roles('namenode')
def setupNamenode():
    setupHadoop()
    #format namenode
    with cd(conf['hadoop']['bin_dir']):
        runCmd("su %s -c \"./hadoop namenode -format\"" % conf['hadoop']['username'])
        
@roles('namenode')
def stopNamenode():
    with cd(conf['hadoop']['bin_dir']):
        runCmd("su %s -c \"./hadoop-daemon.sh stop namenode\"" % conf['hadoop']['username'])

@roles('namenode')
def startNamenode():
    with cd(conf['hadoop']['bin_dir']):
        runCmd("su %s -c \"./hadoop-daemon.sh start namenode\"" % conf['hadoop']['username'])
        
@roles('jobtracker')
def setupJobtracker():
    if conf['hosts']['jobtracker'] == conf['hosts']['namenode']:
        print "jobtracker same machine as namenode, Already setup"
    else:
        setupHadoop()

@roles('jobtracker')
def stopJobtracker():
    with cd(conf['hadoop']['bin_dir']):
        runCmd("su %s -c \"./hadoop-daemon.sh stop jobtracker\"" % conf['hadoop']['username'])

@roles('jobtracker')
def startJobtracker():
    with cd(conf['hadoop']['bin_dir']):
        runCmd("su %s -c \"./hadoop-daemon.sh start jobtracker\"" % conf['hadoop']['username'])

@roles('slave')
def stopTasktracker():
    with cd(conf['hadoop']['bin_dir']):
        runCmd("su %s -c \"./hadoop-daemon.sh stop tasktracker\"" % conf['hadoop']['username'])

@roles('slave')
def startTasktracker():
    with cd(conf['hadoop']['bin_dir']):
        runCmd("su %s -c \"./hadoop-daemon.sh start tasktracker\"" % conf['hadoop']['username'])

@roles('slave')
def setupSlave():
    setupHadoop()

@roles('slave')
def stopSlave():
    with cd(conf['hadoop']['bin_dir']):
        runCmd("su %s -c \"./hadoop-daemon.sh stop datanode\"" % conf['hadoop']['username'])
        runCmd("su %s -c \"./hadoop-daemon.sh stop tasktracker\"" % conf['hadoop']['username'])

@roles('slave')
def startSlave():
    with cd(conf['hadoop']['bin_dir']):
        runCmd("su %s -c \"./hadoop-daemon.sh start datanode\"" % conf['hadoop']['username'])
        runCmd("su %s -c \"./hadoop-daemon.sh start tasktracker\"" % conf['hadoop']['username'])

def setupHadoop():
    formatDrives()
    mountDrives()
    putHadoopConf()
    createLocalPaths()
    if conf['hosts']['update_ulimit']:
        updateUlimit()
    
def hostname():
    runCmd("hostname")
    
def formatDrives(force=False):
    if conf['hdd']['format'] or force:
        for drive in conf['hdd']['drives']:
            try:
                runCmd("umount -l %s" % drive)
            except:
                pass
            runCmd("echo \"y\" | mkfs.ext4 %s" % drive)
            
def mountDrives(force=False):
    if conf['hdd']['auto_mount'] or force:
        for mpoint in conf['hdd']['mount_locations']:
            if not fabric_exists(mpoint['mount_point']):
                runCmd("mkdir -p %s" % mpoint['mount_point'])
            runCmd("mount %s %s" % (mpoint['drive'],mpoint['mount_point']))
        
def putHadoopConf():
    confdir = conf['hadoop']['conf_dir']
    put('mapred-site.xml',confdir)
    put('core-site.xml',confdir)
    put('hdfs-site.xml',confdir)
    put('hadoop-env.sh',confdir)

def updateUlimit():
    put("limits.conf","/etc/security",use_sudo=True)


def createLocalPaths():
    tree = etree.parse("core-site.xml")
    user = conf['hadoop']['username']
    
    tmpdir = tree.xpath("//property[name='hadoop.tmp.dir']/child::value")[0].text.split(",")
    
    tree = etree.parse("hdfs-site.xml")
    namedir = tree.xpath("//property[name='dfs.name.dir']/child::value")[0].text.split(",")
    datadir = tree.xpath("//property[name='dfs.data.dir']/child::value")[0].text.split(",")

    tree = etree.parse("mapred-site.xml")
    mrlocaldir = tree.xpath("//property[name='mapred.local.dir']/child::value")[0].text.split(",")
    
    dirs = tmpdir+namedir+datadir+mrlocaldir
    print dirs
    
    for d in dirs:
        runCmd("mkdir -p %s" % d)
        runCmd("chown -R %s:%s %s" %(user,user,d))
    runCmd("chmod 777 %s" % tmpdir[0])
    
def hostname():
    run('hostname')

def putetgz(filename):
    put(filename)
    run("tar zxf %s" % filename)

def disableiptables():
    sudo('iptables -P INPUT ACCEPT')
    sudo('iptables -P OUTPUT ACCEPT')
    sudo('iptables -P FORWARD ACCEPT')
    sudo('iptables -F')

def removeHosts():
    sudo('mv /etc/hosts /etc/hosts.old')
