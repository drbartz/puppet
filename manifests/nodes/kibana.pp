# install graphite from git 
node /kibana.*/ {
    include basic
    include puppet::client
    include graphite::diamond
    include elasticsearch
    include logstash
    include kibana
    #include zabbix::agent
    Class['puppet::client'] -> Class['basic']
}
