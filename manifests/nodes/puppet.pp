node 'puppet' {
	include basic
	include puppet::client
	include puppet::server
	#include graphite::collect 	#discoment if you have the Graphite server installed
	#include zabbix::agent 			#discoment if you have the Zabbix server installed
}
