#!/bin/bash

name="kibana"
build_dir="/tmp/${name}"
TMP_File="/tmp/${name}/.install"
version="4.0.0-linux-x64"

if [[ ! -f "${TMP_File}" ]]
then 
	[[ -d  ${build_dir} ]] && rm -rf "${build_dir}"
	install -d ${build_dir}
    # Install ElasticSearch RPM
    cd /opt
    wget https://download.elasticsearch.org/kibana/kibana/${name}-${version}.tar.gz
    tar -zxvf ${name}-${version}.tar.gz
    ln -s ${name}-${version} ${name}
    date > ${TMP_File}
fi
