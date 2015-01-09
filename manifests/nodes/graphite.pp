# install graphite from git 
node /graphite01.*/ {
	include basic
	include puppet::client
	include graphite::server_git
	include zabbix::agent
}
