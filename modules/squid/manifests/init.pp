class squid {

    group { 'squid':
        ensure => present,
    }

    user { 'squid':
        ensure     => present,
        gid        => 'squid',
        groups     => ['squid'],
        membership => minimum,
        shell      => '/sbin/nologin',
        require    => Group['squid'],
    }

    package { 'squid':
        ensure	=> present,
    }

    file {'/var/log/squid':
        ensure  => directory,
        owner   => 'squid',
        group   => 'squid',
        require => [
            User['squid'],
            Package['squid'],
        ],
    }

    file {'/etc/diamond/configs/squid.conf':
        ensure  => present,
        content => file('squid/diamond_squid.conf'),
        require => File['/etc/diamond/configs'],
        notify  => Service['diamond'],
    }

    service { 'squid':
        ensure      => running,
        enable      => true,
        hasstatus   => 'true',
        hasrestart  => 'true',
        require     => [
            Package['squid'],
            File['/var/log/squid'],
        ],
    }
}
