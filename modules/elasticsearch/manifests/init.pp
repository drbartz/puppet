class elasticsearch (
    $graphite01 = '10.10.10.3', 
    $graphite02 = '10.10.10.4', 
    $elasticsearch01 = $graphite01, 
    $elasticsearch02 = $graphite01, 
    ) {

    exec { '/tmp/.install_elasticsearch.sh' :
        cwd     => "/tmp",
        creates => '/tmp/elasticsearch/.install',
        require =>  File['/tmp/.install_elasticsearch.sh'],
    }

    file { '/tmp/.install_elasticsearch.sh':
        ensure  => present,
        content => file('elasticsearch/install_elasticsearch.sh'),
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
    }

    file { '/etc/init.d/elasticsearch':
        ensure  => present,
        content => file('elasticsearch/init_elasticsearch'),
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
    }

    file { '/etc/elasticsearch/elasticsearch.yml':
        ensure  => present,
        content => file('elasticsearch/elasticsearch.yml'),
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        require => Exec['/tmp/.install_elasticsearch.sh'],
        notify  => Service['elasticsearch'],
    }

    service { 'elasticsearch':
        ensure  => running,
        enable  => true,
        require => Exec['/tmp/.install_elasticsearch.sh'],
    }

}
