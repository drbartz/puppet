node /zabbix*/ {
	include basic
	include httpd
	include mysqld
	#include graphite::collect 	#discoment if you have the Graphite server installed
	include zabbix::repo
	include zabbix::agent
	include zabbix::server
	Class['basic'] -> Class['httpd'] -> Class['mysqld'] 
}
