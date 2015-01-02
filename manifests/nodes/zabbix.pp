node /zabbix01.*/ {
	include basic
	include httpd
	include mysqld
	include zabbix::server
	#Class['basic'] -> Class['httpd'] -> Class['mysqld'] -> Class['zabbix::server']
}
