# install graphite from git 
node /graphite01.*/ {
<<<<<<< HEAD
	include basic
	include puppet::client
	include graphite::server_git
	include graphite::collect
	#include zabbix::agent 			#discoment if you have the Zabbix server installed
=======
    include basic
    include puppet::client
    include graphite::server_git
    include graphite::diamond
    #include zabbix::agent
    Class['puppet::client'] -> Class['basic'] -> Class['graphite::server_git'] 
>>>>>>> graphite_skyline
}
