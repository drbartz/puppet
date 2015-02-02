node /oculus.*/ {
    include basic
    include puppet::client
    #include zabbix::agent
    include graphite::collect
    include oculus
    Class['puppet::client'] -> Class['basic'] -> Class['graphite::collect'] -> Class['oculus']
}
