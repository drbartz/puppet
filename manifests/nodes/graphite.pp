# install graphite from git 
node /graphite0.*/ {
    include basic
    include puppet::client
    include graphite::server
    include graphite::diamond
    include elasticsearch
    include grafana
    #include rsyslog
    #include logstash::forwarder
    #include zabbix::agent
    Class['puppet::client'] -> Class['basic'] -> Class['graphite::server'] 
}
