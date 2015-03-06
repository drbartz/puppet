class grafana {
    include httpd
    $graphite01 = '10.10.10.3'
    $graphite02 = '10.10.10.4'
    $elasticsearch01 = $graphite01
    $elasticsearch02 = $graphite01

    exec { '/tmp/.install_grafana.sh' :
        cwd     => "/tmp",
        creates => '/opt/grafana/.install',
        require =>  File['/tmp/.install_grafana.sh'],
    }

    file { '/tmp/.install_grafana.sh':
        ensure  => present,
        content => file('grafana/install_grafana.sh'),
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
    }

   file { '/etc/httpd/conf.d/grafana.conf':
        ensure  => present,
        content => file('grafana/http_grafana.conf'),
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        require => Package['httpd'],
        notify  => Service['httpd'],
    }

   file { '/opt/grafana/config.js':
        ensure  => present,
        content => template('grafana/config.js.erb'),
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        require => Package['httpd'],
        notify  => Service['httpd'],
    }
}
