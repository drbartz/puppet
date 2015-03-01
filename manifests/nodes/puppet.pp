node 'puppet' {
    include basic
    include puppet::client
    include puppet::client_fast
    include puppet::server
    #include zabbix::agent
    include graphite::diamond
    include autocache
    include httpd
    include squid
    include logstash::forwarder
    Class['puppet::client'] -> Class['basic'] -> Class['puppet::server'] -> Class['puppet::client_fast']
}
