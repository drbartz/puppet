node /zabbix*/ {
    include basic
    include httpd
    include mysqld
    include zabbix::repo
    include zabbix::agent
    include zabbix::server
    include graphite::diamond
    Class['puppet::client'] -> Class['basic'] -> Class['graphite::diamond'] -> Class['httpd'] -> Class['mysqld'] 
}
