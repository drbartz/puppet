class redis {
    
    group { 'redis':
        ensure => present,
    }

    user { 'redis':
        ensure     => present,
        gid        => 'redis',
        groups     => ['redis'],
        membership => minimum,
        shell      => '/sbin/nologin',
        require    => Group['redis'],
    }

    file {'/var/run/redis':
        ensure  => directory,
        mode    => '0755',
        owner   => 'redis',
        group   => 'redis',
        require => User['redis'],
    }

    file {'/var/cache/redis-snapshot':
        ensure  => directory,
        mode    => '0755',
        owner   => 'redis',
        group   => 'redis',
        require => User['redis'],
    }

    file {'/var/log/redis':
        ensure  => directory,
        mode    => '0755',
        owner   => 'redis',
        group   => 'redis',
        require => User['redis'],
    }

    file {'/var/lib/redis':
        ensure  => directory,
        mode    => '0755',
        owner   => 'redis',
        group   => 'redis',
        require => User['redis'],
    }

	file {'/root/.install_redis.sh':
		ensure	=> present,
		content	=> file('redis/install_redis.sh'),
		mode		=> '0755',
		owner		=> 'root',
		group		=> 'root',
	}
	
	file {'/etc/init.d/redis':
		ensure	=> present,
		content	=> file('redis/init_redis'),
		mode		=> '0755',
		owner		=> 'root',
		group		=> 'root',
	}
	
	exec {'/root/.install_redis.sh':
		creates	=> "/root/.install_redis.sh.done",
		require	=> File['/root/.install_redis.sh'],
	}

	file {'/etc/redis.conf':
		ensure  => present,
		content => file('redis/redis.conf'),
		require	=> Exec['/root/.install_redis.sh'],
		notify  => Service['redis'],
	}

    file {'/etc/diamond/configs/redis.conf':
        ensure  => present,
		content => file('redis/diamond_redis.conf'),
        require => Exec['/tmp/.install_diamond.sh'], 
        notify  => Service['diamond'],
    }

	service { 'redis':
		ensure	=> running,
		enable	=> true,
		require	=> [
            Exec['/root/.install_redis.sh'],
		    File['/etc/init.d/redis'],
		    File['/var/run/redis'],
		    File['/var/log/redis'],
        ],
	}

}
