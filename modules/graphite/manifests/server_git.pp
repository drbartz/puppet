class graphite::server_git {
    include httpd
    $skyline01 = '10.10.10.6'
    $graphite01 = '10.10.10.3'
    $graphite02 = '10.10.10.4'

    define init_carbon ( $test = $title, $carbon_name) { 
        file { "${carbon_name}":
            path    => "/etc/init.d/carbon-${carbon_name}",
            ensure  => present,
            content => template('graphite/init_carbon.erb'),
            mode    => '0755',
            owner   => 'root',
            group   => 'root',
            notify  => Service["carbon-${carbon_name}"],
        }
    }

    package { [ 'libffi-devel', 'mod_wsgi' ]:
        ensure => installed,
    }
    package { [ 'python-pip', 'pycairo', 'Django14', 'python-ldap', 'python-memcached', 'python-sqlite2', 'bitmap', 'bitmap-fonts-compat', 'python-devel', 'python-crypto', 'pyOpenSSL', 'gcc', 'python-zope-filesystem', 'python-zope-interface',  'gcc-c++', 'zlib-static', 'MySQL-python', 'python-txamqp', 'python-setuptools', 'python-psycopg2', 'dejavu-sans-fonts', 'dejavu-serif-fonts']:
        ensure => installed,
        require => Package['epel-release'],
    }

    exec { '/opt/graphite/install_graphite.sh' :
        cwd     => "/opt/graphite",
        creates => '/opt/graphite/.install',
        require    => [
            File['/opt/graphite'],
            File['/opt/graphite/install_graphite.sh'],
        ],
    }

    file { '/var/log/carbon':
        ensure    => directory,
        mode      => '0644',
        owner     => 'carbon',
        group     => 'carbon',
    }

    file { '/opt/graphite':
        ensure    => directory,
        mode      => '0644',
        owner     => 'carbon',
        group     => 'carbon',
    }
                                            
    file { '/opt/graphite/install_graphite.sh':
        ensure    => present,
        content   => file('graphite/install_graphite.sh'),
        mode      => '0755',
        owner     => 'root',
        group     => 'root',
        require    => File['/opt/graphite'],
    }
    
    group { 'carbon':
        ensure => present,
    }

    user { 'carbon':
        ensure     => present,
        gid        => 'carbon',
        groups     => ['root', 'carbon'],
        membership => minimum,
        shell      => '/sbin/nologin',
        require    => Group['carbon'],
    }

   file { '/etc/httpd/conf.d/graphite.conf':
        ensure    => present,
        content   => template('graphite/http_graphite.conf.erb'),
        mode      => '0644',
        owner     => 'root',
        group     => 'root',
        require    => Package['httpd'],
        notify     => Service['httpd'],
    }

   file { '/etc/sysconfig/iptables':
        ensure    => present,
        content   => file('graphite/iptables'),
        mode      => '0644',
        owner     => 'root',
        group     => 'root',
        require    => Package['iptables'],
        notify    => Service['iptables'],
    }

   init_carbon { 'carbon-cache':
        carbon_name => 'cache',
    }

   init_carbon { 'carbon-relay':
        carbon_name => 'relay',
    }

   init_carbon { 'carbon-aggregator':
        carbon_name => 'aggregator',
    }

   file { '/opt/graphite/conf/graphite.wsgi':
        ensure    => present,
        content   => file('graphite/graphite.wsgi'),
        mode      => '0755',
        owner     => 'apache',
        group     => 'apache',
        notify     => Service['httpd'],
        require    => [
            Package['httpd'],
            Exec['/opt/graphite/install_graphite.sh'],
        ],
    }

   file { '/opt/graphite/conf/storage-schemas.conf':
        ensure    => present,
        content   => file('graphite/storage-schemas.conf'),
        mode      => '0644',
        owner     => 'carbon',
        group     => 'carbon',
        notify     => [
            Service['carbon-cache'],
            Service['carbon-relay'],
            Service['carbon-aggregator'],
        ],
        require    => Exec['/opt/graphite/install_graphite.sh'],
    }

   file { '/opt/graphite/webapp/graphite/local_settings.py':
        ensure    => present,
        content   => template('graphite/local_settings.py.erb'),
        mode      => '0644',
        owner     => 'apache',
        group     => 'apache',
        notify     => Service['httpd'],
        require    => [
            Package['httpd'],
            Exec['/opt/graphite/install_graphite.sh'],
        ],
    }

   file { '/opt/graphite/conf/carbon.conf':
        ensure    => present,
        content   => template('graphite/carbon.conf.erb'),
        mode      => '0644',
        owner     => 'carbon',
        group     => 'carbon',
        notify     => [
            Service['carbon-cache'],
            Service['carbon-relay'],
            Service['carbon-aggregator'],
        ],
        require    => Exec['/opt/graphite/install_graphite.sh'],
    }

   file { '/opt/graphite/conf/storage-aggregation.conf':
        ensure    => present,
        content   => file('graphite/storage-aggregation.conf'),
        mode      => '0644',
        owner     => 'carbon',
        group     => 'carbon',
        notify     => [
            Service['carbon-cache'],
            Service['carbon-relay'],
            Service['carbon-aggregator'],
        ],
        require    => Exec['/opt/graphite/install_graphite.sh'],
    }

   file { '/opt/graphite/conf/relay-rules.conf':
        ensure    => present,
        content   => file('graphite/relay-rules.conf'),
        mode      => '0644',
        owner     => 'carbon',
        group     => 'carbon',
        notify     => [
            Service['carbon-relay'],
        ],
        require    => Exec['/opt/graphite/install_graphite.sh'],
    }

   file { '/opt/graphite/conf/aggregation-rules.conf':
        ensure    => present,
        content   => file('graphite/aggregation-rules.conf'),
        mode      => '0644',
        owner     => 'carbon',
        group     => 'carbon',
        notify     => [
            Service['carbon-aggregator'],
        ],
        require    => Exec['/opt/graphite/install_graphite.sh'],
    }

   file { '/etc/logrotate.d/carbon':
        ensure    => present,
        content   => file('graphite/logrotate_carbon'),
        mode      => '0644',
        owner     => 'root',
        group     => 'root',
        require    => Exec['/opt/graphite/install_graphite.sh'],
    }

    service { 'iptables':
        ensure    => running,
        enable    => true,
        require    => Package['iptables'],
    }

    service { 'carbon-cache':
        ensure    => running,
        enable    => true,
        require    => [ 
            Init_carbon['carbon-cache'],
            File['/opt/graphite/conf/carbon.conf'],
            File['/opt/graphite/conf/storage-schemas.conf'],
            Exec['/opt/graphite/install_graphite.sh'],
        ],
    }

    service { 'carbon-relay':
        ensure    => running,
        enable    => true,
        require    => [ 
            File['/etc/init.d/carbon-relay'],
            File['/opt/graphite/conf/carbon.conf'],
            File['/opt/graphite/conf/relay-rules.conf'],
            File['/opt/graphite/conf/storage-schemas.conf'],
            Exec['/opt/graphite/install_graphite.sh'],
        ],
    }

    service { 'carbon-aggregator':
        ensure    => running,
        enable    => true,
        require    => [ 
            File['/etc/init.d/carbon-aggregator'],
            File['/opt/graphite/conf/carbon.conf'],
            File['/opt/graphite/conf/storage-aggregation.conf'],
            File['/opt/graphite/conf/storage-schemas.conf'],
            Exec['/opt/graphite/install_graphite.sh'],
        ],
    }

}
