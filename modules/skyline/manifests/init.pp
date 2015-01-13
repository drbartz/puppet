class skyline {
	include redis
	package { ['python-pip', 'gcc', 'python-devel', 'gcc-c++', 'lapack', 'lapack-devel', 'blas', 'blas-devel', 'redis', 'scipy']:
		ensure	=> present,
		require	=> Package['epel-release'],
	}

	file { '/etc/init.d/skyline-analyzer':
		ensure    => present,
		content   => file('skyline/init_skyline_analyzer'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
		notify	 => Service['skyline-analyzer'],
		require	=> Exec['/tmp/.install_skyline.sh'],
	}

	file { '/etc/init.d/skyline-horizon':
		ensure    => present,
		content   => file('skyline/init_skyline_horizon'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
		notify	 => Service['skyline-horizon'],
		require	=> Exec['/tmp/.install_skyline.sh'],
	}

	file { '/etc/init.d/skyline-web':
		ensure    => present,
		content   => file('skyline/init_skyline_web'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
		notify	 => Service['skyline-web'],
		require	=> Exec['/tmp/.install_skyline.sh'],
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
		require	=> Exec['/tmp/.install_skyline.sh'],
	}

	file { '/tmp/.install_skyline.sh':
		ensure    => present,
		content   => file('skyline/install_skyline.sh'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
	}

	exec {'/tmp/.install_skyline.sh':
		cwd	=>  '/opt/',
		creates	=> '/opt/skyline/.install.done',
		require	=> [
			File['/tmp/.install_skyline.sh'],
			Package['scipy'],
			Package['python-pip'],
		],
	}

	service { 'skyline-analyzer':
		ensure	=> running,
		enable	=> true,
		require	=> [
			File['/etc/init.d/skyline-analyzer'],
			Exec['/tmp/.install_skyline.sh'],
		],
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
