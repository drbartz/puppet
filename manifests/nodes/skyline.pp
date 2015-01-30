node /skyline.*/ {
    include basic
    include graphite::collect
    include puppet::client
    #include zabbix::agent
    include skyline
    Class['puppet::client'] -> Class['basic'] -> Class['graphite::collect'] -> Class['skyline']
}
