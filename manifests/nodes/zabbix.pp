node /zabbix*/ {
	include basic
	include httpd
	include mysqld
	include zabbix::repo
	include zabbix::agent
	include zabbix::server
	include graphite::collect
	Class['basic'] -> Class['httpd'] -> Class['mysqld'] 
}
