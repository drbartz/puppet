class kibana (
    $graphite01 = '10.10.10.3', 
    $graphite02 = '10.10.10.4', 
    $kibana01 = $graphite01, 
    $kibana02 = $graphite01, 
    $elasticsearch01= '10.10.10.4', 
    ) {

    exec { '/tmp/.install_kibana.sh' :
        cwd     => "/tmp",
        creates => '/tmp/kibana/.install',
        require =>  File['/tmp/.install_kibana.sh'],
    }

    file { '/etc/init.d/kibana':
        ensure  => present,
        content => file('kibana/init_kibana'),
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
    }

    file { '/tmp/.install_kibana.sh':
        ensure  => present,
        content => file('kibana/install_kibana.sh'),
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
    }

   file { '/etc/sysconfig/iptables':
        ensure  => present,
        content => file('kibana/iptables'),
        mode    => '0600',
        owner   => 'root',
        group   => 'root',
        require => Package['iptables'],
        notify  => Service['iptables'],
    }

#    package { 'kibana':
#        ensure => installed,
#        name => 'https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-linux-x64.tar.gz',
#    }

    file { '/opt/kibana/config/kibana.yml':
        ensure  => present,
        content => template('kibana/kibana.yml.erb'),
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        require => Exec['/tmp/.install_kibana.sh'],
        notify  => Service['kibana'],
    }

    service { 'kibana':
        ensure  => running,
        enable  => true,
        require => File['/etc/init.d/kibana'],
    }

    service { 'iptables':
        ensure  => running,
        enable  => true,
        require => Package['iptables'],
    }

}
