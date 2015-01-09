node 'puppet' {
	include basic
	include puppet::client
	include puppet::server
	#include zabbix::agent
}
