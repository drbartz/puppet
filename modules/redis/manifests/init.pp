class redis {

	file {'/root/.install_redis.sh':
		ensure	=> present,
		content	=> file('redis/install_redis.sh'),
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

	service { 'redis':
		ensure	=> running,
		enable	=> true,
		require	=> Exec['/root/.install_redis.sh'],
	}

}
