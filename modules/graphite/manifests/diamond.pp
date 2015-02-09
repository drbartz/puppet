class graphite::diamond {

    package {'python-configobj':
        ensure  => present,
    }

    file {'/etc/diamond/configs':
        ensure  => directory,
        require => Exec['/tmp/.install_diamond.sh'],
    }
    
    exec { '/tmp/.install_diamond.sh' :
        cwd     => "/tmp",
        creates => '/usr/bin/diamond',
        require => [
            File['/tmp/.install_diamond.sh'],
            Package['git'],
            Package['python-configobj'],
        ],
    }

    file { '/tmp/.install_diamond.sh':
        ensure    => present,
        content   => file('graphite/install_diamond.sh'),
        mode      => '0755',
        owner     => 'root',
        group     => 'root',
    }

#	group { 'diamond':
#		ensure => present,
#	}
#
#	user { 'diamond':
#		ensure     => present,
#		gid        => 'diamond',
#		groups     => ['diamond'],
#		membership => minimum,
#		shell      => '/sbin/nologin',
#		require    => Group['diamond'],
#	}

   file { '/etc/diamond/diamond.conf':
        ensure    => present,
        content   => file('graphite/diamond.conf'),
        mode      => '0755',
        owner     => 'root',
        group     => 'root',
        notify  => Service['diamond'],
    }

    service { 'diamond':
        ensure	=> running,
        enable	=> true,
        require	=> [ 
            File['/etc/diamond/diamond.conf'],
            Exec['/tmp/.install_diamond.sh'],
        ],
    }

}
