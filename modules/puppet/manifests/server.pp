class puppet::server ( 
) {
    include autocache

    package {'hiera':
        ensure  => present,
    }

    file { '/etc/puppet/hiera.yaml':
        ensure    => present,
        content   => file('puppet/hiera.yaml'),
        mode      => '0644',
        owner     => 'root',
        group     => 'root',
    }

    file { '/etc/puppet/hieradata':
        ensure    => directory,
        owner     => 'root',
        group     => 'root',
    }

    file { '/etc/puppet/autosign.conf':
        ensure    => present,
        content   => file('puppet/autosign.conf'),
        mode      => '0644',
        owner     => 'root',
        group     => 'root',
    }

    file { '/root/clean_cert.sh':
        ensure    => present,
        content   => file('puppet/clean_cert.sh'),
        mode      => '0755',
        owner     => 'root',
        group     => 'root',
    }

    file {'/etc/sysconfig/iptables':
        ensure  => present,
        content => file('puppet/iptables'),
        mode        => '0600',
        owner       => 'root',
        group       => 'root',
        require => Package['iptables'],
        notify  => Service['iptables'],
    }

    service {'iptables':
        ensure  => running,
        enable  => true,
        require => [
            File['/etc/sysconfig/iptables'],
            Package['iptables'],
        ],  
    }
}
