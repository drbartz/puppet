#!/bin/bash

name="grafana"
build_dir="/tmp/${name}"
TMP_File="/opt/${name}/.install"

if [[ ! -f "${TMP_File}" ]]
then 
	grafana_version="1.9.1"
	[[ -d  ${build_dir} ]] && rm -rf "${build_dir}"
	install -d ${build_dir}
	cd ${build_dir}
	curl -s -L http://grafanarel.s3.amazonaws.com/grafana-${grafana_version}.tar.gz | tar xz
    mv ${build_dir}/grafana-${grafana_version} /opt/.
    cd /opt
    ln -sf grafana-${grafana_version} grafana
	chown -R carbon:carbon /opt/grafana
	chcon -R -h -t httpd_sys_content_t /opt/grafana
	#service httpd restart
	date > ${TMP_File}
fi
