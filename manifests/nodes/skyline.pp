node /skyline.*/ {
	include basic
	include puppet::client
	include redis
	include graphite::collect
	#include zabbix::agent 			#discoment if you have the Zabbix server installed
}
