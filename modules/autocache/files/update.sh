#!/bin/bash

LOCAL_PATH='/opt/autocache/rpm-cache'
[ -d ${LOCAL_PATH} ] || install -d ${LOCAL_PATH}
cd ${LOCAL_PATH}

Update=0
#get the file list from squid log

tail -500 /var/log/squid/access.log | grep -v "10.10.10.2" | awk '/rpm/ {NF=split($7,t,"/");print $7, t[NF] }' | while read url file_name
do 
    if [ "x" != "${file_name}x" ]
    then 
        if [ -f ${file_name} ]
        then 
            #echo "file exist: ${file_name}"
            OK=1
        else   
            echo "download file: ${file_name}"
            wget -e use_proxy=yes -e http_proxy=10.10.10.2:3128 $url
            Update=1
        fi
    fi
done

# update repository

if [ ${Update} -eq 1 ]
then
    pushd ${LOCAL_PATH} >/dev/null 2>&1
    createrepo .
    popd
fi
