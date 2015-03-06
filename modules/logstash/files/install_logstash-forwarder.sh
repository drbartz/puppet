#!/bin/bash

name="logstash-forwarder"
build_dir="/tmp/${name}"
TMP_File="/tmp/${name}/.install"
version="4.0.0-linux-x64"

if [[ ! -f "${TMP_File}" ]]
then 
	[[ -d  ${build_dir} ]] && rm -rf "${build_dir}"
	install -d ${build_dir}
    # Install ElasticSearch RPM
    cd /opt
    git clone git://github.com/elasticsearch/logstash-forwarder.git
    cd logstash-forwarder
    go build
    date > ${TMP_File}
fi
