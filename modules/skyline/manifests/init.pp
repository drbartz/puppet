class skyline {

	file { '/etc/init.d/skyline-analyzer':
		ensure    => present,
		content   => file('skyline/init_skyline_analyzer'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
		notify	 => Service['skyline-analyzer'],
	}

	file { '/etc/init.d/skyline-horizon':
		ensure    => present,
		content   => file('skyline/init_skyline_horizon'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
		notify	 => Service['skyline-horizon'],
	}

	file { '/etc/init.d/skyline-web':
		ensure    => present,
		content   => file('skyline/init_skyline_web'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
		notify	 => Service['skyline-web'],
	}

	file { '/opt/skyline/src/settins.py':
		ensure    => present,
		content   => file('skyline/skyline_settings.py'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
		notify	 => [
			Service['skyline-analyzer'],
			Service['skyline-horizon'],
			Service['skyline-web'],
		],
	}

	service { 'skyline-analyzer':
		ensure	=> running,
		enable	=> true,
		require	=> File['/etc/init.d/skyline-analyzer'],
	}

	service { 'skyline-horizon':
		ensure	=> running,
		enable	=> true,
		require	=> File['/etc/init.d/skyline-horizon'],
	}

	service { 'skyline-web':
		ensure	=> running,
		enable	=> true,
		require	=> File['/etc/init.d/skyline-web'],
	}

}
