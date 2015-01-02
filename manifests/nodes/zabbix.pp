node /zabbix*/ {
	include basic
	include httpd
	include mysqld
	include zabbix::server
	include zabbix::client
	#Class['basic'] -> Class['httpd'] -> Class['mysqld'] -> Class['zabbix::server']
}
