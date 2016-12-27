# install hubot from git 
node /hubot0*/ {
    include basic
    include puppet::client
#    include graphite::server_git
#    include graphite::diamond
#    include elasticsearch
#    include grafana
    #include rsyslog
    #include logstash::forwarder
    #include zabbix::agent
    #Class['puppet::client'] -> Class['basic'] -> Class['graphite::server_git'] 
    Class['puppet::client'] -> Class['basic']
}
