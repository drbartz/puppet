node /zabbix*/ {
	include basic
	include httpd
	include mysqld
	include zabbix::repo
	include zabbix::agent
	include zabbix::server
	Class['basic'] -> Class['httpd'] -> Class['mysqld'] 
	#-> Class['zabbix::repo'] -> Class['zabbix::server'] -> Class['zabbix::agent']
}
