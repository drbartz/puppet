class puppet::client_fast {

    file {'/etc/yum.conf':
        ensure  => present,
        content => file('puppet/client_yum.conf'),
        require => Package['puppet'],
    }

    file {'/etc/yum.repos.d/autocache.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => file('puppet/autocache.repo'),
        require => Package['puppet'],
    }

}

