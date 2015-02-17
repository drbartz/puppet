class skyline {
	package { ['python-pip', 'gcc', 'python-devel', 'gcc-c++', 'lapack', 'lapack-devel', 'blas', 'blas-devel']: 
		ensure	=> present,
		require	=> Package['epel-release'],
	}

	file {'/etc/sysconfig/iptables':
		ensure	=> present,
		content	=> file('skyline/iptables'),
		mode		=> '0600',
		owner		=> 'root',
		group		=> 'root',
		require	=> Package['iptables'],
		notify	=> Service['iptables'],
	}

	file {'/var/log/skyline':
		ensure	=> directory,
		owner	=> 'root',
		group	=> 'root',
	}

	file {'/var/run/skyline':
		ensure	=> directory,
		owner	=> 'root',
		group	=> 'root',
	}

	file { '/etc/init.d/skyline-analyzer':
		ensure	=> present,
		content	=> file('skyline/init_skyline_analyzer'),
		mode	=> '0755',
		owner	=> 'root',
		group	=> 'root',
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

	file { '/opt/skyline/src/settings.py':
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
		timeout     => 1800,
		require	=> [
			File['/tmp/.install_skyline.sh'],
			Package['gcc'], 
			Package['gcc-c++'],
			Package['python-devel'], 
			Package['python-pip'],
			Package['lapack'], 
			Package['lapack-devel'],
			Package['blas'], 
			Package['blas-devel'], 
			#Exec['python-scipy'],
			#Exec['python-statsmodels'],
			File['/var/log/skyline'],
			File['/var/run/skyline'],
		],
	}

	service {'iptables':
		ensure	=> running,
		enable	=> true,
		require	=> [
			File['/etc/sysconfig/iptables'],
			Package['iptables'],
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
