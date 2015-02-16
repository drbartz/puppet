#!/bin/bash

RPM_DIR='/opt/autocache/rpm-cache'
REPO_DIR=${RPM_DIR}'/repodata'

function RPM_COUNT() {
    find ${RPM_DIR} -type f -name '*.rpm' | wc -l
}

function Download() {
    echo "Download firs package"
    cd $RPM_DIR
    wget http://mirror.centos.org/centos/6/os/x86_64/Packages/telnet-0.17-48.el6.x86_64.rpm
    pushd ${RPM_DIR}
    createrepo /opt/autocache/
    popd
}

function Update() {
    cd $RPM_DIR
    if [ ! -d ${REPO_DIR} ] 
    then
        if [ -f `which createrepo` ]
        then
            [ -f '/etc/yum.repos.d/autocache.repo' ] && rm -f /etc/yum.repos.d/autocache.repo
            yum install -y createrepo
        fi
        createrepo ${RPM_DIR}
    fi
}


[ -d ${RPM_DIR} ] || install -d ${RPM_DIR}
[ 0 -eq `RPM_COUNT` ] && Download
[ 0 -lt `RPM_COUNT` ] && Update


