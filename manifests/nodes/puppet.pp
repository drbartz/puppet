node 'puppet' {
    include basic
    include puppet::client
    include puppet::server
    #include zabbix::agent
    include graphite::collect
    Class['puppet::client'] -> Class['basic'] -> Class['graphite::collect'] -> Class['puppet::server']
}
