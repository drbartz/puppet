node /zabbix*/ {
    include basic
    include puppet::client
    include httpd
    include mysqld
    include zabbix::repo
    include zabbix::agent
    include zabbix::server
    include graphite::diamond
    include rsyslog
    Class['puppet::client'] -> Class['basic'] -> Class['graphite::diamond'] -> Class['mysqld'] 
}
