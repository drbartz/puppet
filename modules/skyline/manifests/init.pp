class skyline {
	include redis
	package { ['python-pip', 'gcc', 'python-devel', 'gcc-c++', 'lapack', 'lapack-devel', 'blas', 'blas-devel', 'redis', 'iptables']: 
		ensure	=> present,
		require	=> Package['epel-release'],
	}

	file {'/etc/sysconfig/iptables':
		ensure	=> present,
		content	=> file('skyline/iptables'),
		mode		=> '0600',
		owner		=> 'root',
		group		=> 'root',
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
			#Exec['/usr/bin/pip install scipy --upgrade'],
			Exec['python-scipy'],
			Exec['python-statsmodels'],
			File['/var/log/skyline'],
			File['/var/run/skyline'],
		],
	}

	# install from GIT: use to generate a new TGZ for next step. Take tooo long!	
	#exec {'/usr/bin/pip install scipy --upgrade':
	#	# 1 hour timeout !!!
	#	timeout     => 3600,
	#	require		=> Exec['/usr/bin/pip install numpy --upgrade'],
	#}

	exec {'python-scipy':
		command	=> '/bin/tar -zxf /vagrant/statsmodels-0.6.1.tgz',
		cwd		=> '/usr/lib64/python2.6/site-packages',
		creates	=> '/usr/lib64/python2.6/site-packages/statsmodels.done',
	}

	exec {'python-statsmodels':
		command	=> '/bin/tar -zxf /vagrant/scipy-0.15.0.tgz',
		cwd		=> '/usr/lib64/python2.6/site-packages',
		creates	=> '/usr/lib64/python2.6/site-packages/scipy.done',
	}

	exec {'/usr/bin/pip install numpy --upgrade':
		timeout     => 1800,
		require		=> Package['python-pip'], 
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
