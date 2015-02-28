node /oculus.*/ {
    include basic
    include puppet::client
    #include zabbix::agent
    include graphite::diamond
    include oculus
    include redis
    include rsyslog
    Class['puppet::client'] -> Class['basic'] -> Class['graphite::diamond'] -> Class['oculus']
}
