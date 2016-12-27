# install errbot from git 
node /errbot0*/ {
    include basic
    include puppet::client
    include errbot
#    include graphite::server_git
#    include graphite::diamond
#    include elasticsearch
#    include grafana
    #include rsyslog
    #include logstash::forwarder
    #include zabbix::agent
    #Class['puppet::client'] -> Class['basic'] -> Class['graphite::server_git'] 
    Class['puppet::client'] -> Class['basic'] -> Class['errbot']
}
