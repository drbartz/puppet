node /oculus.*/ {
	include basic
	include puppet::client
	#include zabbix::agent
	include graphite::collect
    include oculus
}
