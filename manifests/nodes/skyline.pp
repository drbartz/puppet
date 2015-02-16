node /skyline.*/ {
    include basic
    include graphite::diamond
    include puppet::client
    #include zabbix::agent
    include skyline
    Class['puppet::client'] -> Class['basic'] -> Class['graphite::diamond'] -> Class['skyline']
}
