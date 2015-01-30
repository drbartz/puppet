node /zabbix*/ {
    include basic
    include httpd
    include mysqld
    include zabbix::repo
    include zabbix::agent
    include zabbix::server
    include graphite::collect
    Class['puppet::client'] -> Class['basic'] -> Class['graphite::collect'] -> Class['httpd'] -> Class['mysqld'] 
}
