class rsyslog {
    
    package { 'rsyslog':
        ensure	=> present,
    }

    file {'/etc/rsyslog.d/logstash.conf':
        ensure  => present,
        content => file('rsyslog/logstash.conf'),
        require => Package['rsyslog'],
        notify  => Service['rsyslog'],
    }

    service { 'rsyslog':
        ensure      => running,
        enable      => true,
        hasstatus   => 'true',
        hasrestart  => 'true',
        require     => [
            Package['rsyslog'],
            File['/etc/rsyslog.d/logstash.conf'],
        ],
    }
}
