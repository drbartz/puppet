class elasticsearch (
    $graphite01 = '10.10.10.3', 
    $graphite02 = '10.10.10.4', 
    $elasticsearch01 = $graphite01, 
    $elasticsearch02 = $graphite01, 
    ) {

    package { 'java-1.7.0-openjdk':
        ensure  => present,
        require => Package['epel-release'],
    }

    package { 'elasticsearch':
        ensure  => present,
        require => Exec['/tmp/.install_elasticsearch.sh'],
    }    

    exec { '/tmp/.install_elasticsearch.sh' :
        cwd     => "/tmp",
        creates => '/tmp/elasticsearch/.install',
        require =>  [
            File['/tmp/.install_elasticsearch.sh'],
            Package['java-1.7.0-openjdk'],
        ],
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

    file {'/etc/diamond/configs/elasticsearch.conf':
        ensure  => present,
        content => file('elasticsearch/diamond_elasticsearch.conf'),
        require => Exec['/tmp/.install_diamond.sh'],
        notify  => Service['diamond'],
    }

    file { '/etc/elasticsearch/elasticsearch.yml':
        ensure  => present,
        content => file('elasticsearch/elasticsearch.yml'),
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
#        require => Exec['/tmp/.install_elasticsearch.sh'],
        notify  => Service['elasticsearch'],
    }

    service { 'elasticsearch':
        ensure  => running,
        enable  => true,
    #    require => Exec['/tmp/.install_elasticsearch.sh'],
    }

}
