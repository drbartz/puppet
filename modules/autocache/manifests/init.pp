class autocache {

    package {['yum-plugin-priorities', 'createrepo']:
        ensure  => present,
    }

    file {'/opt/autocache':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
    }

    file {'/opt/autocache/update.sh':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => file('autocache/update.sh'),
        require => File['/opt/autocache'],
    }

    file {'/opt/autocache/first_run.sh':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => file('autocache/first_run.sh'),
        require => File['/opt/autocache'],
    }

    file {'/etc/httpd/conf.d/autocache.conf':
        ensure  => present,
        owner   => 'apache',
        group   => 'apache',
        mode    => '0644',
        content => file('autocache/http_autocache.conf'),
        require => Package['httpd'],
        notify  => Service['httpd'],
    }

    file { '/etc/cron.d/autocache':
        ensure    => present,
        content   => file('autocache/cron_autocache'),
        mode      => '0644',
        owner     => 'root',
        group     => 'root',
        require     => File['/opt/autocache/update.sh'],
    }

    exec { '/opt/autocache/first_run.sh':
        cwd     => '/opt/autocache',
        creates => '/opt/autocache/rpm-cache/repodata',
        require => File['/opt/autocache/first_run.sh'],
        notify  => [
            Service['httpd'],
            Service['squid'],
        ],
    }
}
