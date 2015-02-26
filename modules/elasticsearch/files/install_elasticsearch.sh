#!/bin/bash

name="elasticsearch"
build_dir="/tmp/${name}"
TMP_File="/tmp/${name}/.install"

if [[ ! -f "${TMP_File}" ]]
then 
	${name}_version="1.4.3"
	[[ -d  ${build_dir} ]] && rm -rf "${build_dir}"
	install -d ${build_dir}
	cd ${build_dir}
    # Install ElasticSearch RPM
    rpm -Uvh https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.3.noarch.rpm
    # Install Java
	curl -s -L http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.tar.gz | tar xz
    cd jdk1.7.0_75/
    alternatives --install /usr/bin/java java /opt/jdk1.7.0_75/bin/java 2
    alternatives --config java
    alternatives --install /usr/bin/jar jar /opt/jdk1.7.0_75/bin/jar 2
    alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_75/bin/javac 2
    alternatives --set jar /opt/jdk1.7.0_75/bin/jar
    alternatives --set javac /opt/jdk1.7.0_75/bin/javac
	date > ${TMP_File}
fi
