class httpd {
    
    group { 'apache':
        ensure => present,
    }

    user { 'apache':
        ensure     => present,
        gid        => 'apache',
        groups     => ['apache'],
        membership => minimum,
        shell      => '/sbin/nologin',
        require    => Group['apache'],
    }

    package { 'httpd':
        ensure	=> present,
    }

    file {'/var/log/httpd':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        require => [
            Package['httpd'],
            User['apache'],
        ],
    }
    
    file {'/etc/httpd/conf.d/server-status.conf':
        ensure  => present,
        content => file('httpd/server-status.conf'),
        require => Package['httpd'],
        notify  => Service['httpd'],
    }

#    file {'/etc/diamond/configs/httpd.conf':
#        ensure  => present,
#        content => file('httpd/diamond_httpd.conf'),
#        require => Exec['/tmp/.install_diamond.sh'],
#        notify  => Service['diamond'],
#    }

    service { 'httpd':
        ensure      => running,
        enable      => true,
        hasstatus   => 'true',
        hasrestart  => 'true',
        require     => [
            Package['httpd'],
            File['/var/log/httpd'],
        ],
    }
}
