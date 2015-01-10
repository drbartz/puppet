class graphite::collect {

	package { 'python-psutil':
		ensure => installed,
		require => Package['epel-release'],
	}

	file { '/opt/collect':
		ensure    => directory,
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
	}
											
   file { '/etc/init.d/collect':
   	ensure    => present,
      content   => file('graphite/init_collect'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
		require	=> [
			File['/opt/collect/collect.py'],
			File['/opt/collect/settings.py'],
		],
		notify	 => Service['collect'],
	}

   file { '/opt/collect/collect.py':
   	ensure    => present,
      content   => file('graphite/collect.py'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
		notify	 => Service['collect'],
		require	=> File['/opt/collect'],
	}

   file { '/opt/collect/settings.py':
   	ensure    => present,
      content   => file('graphite/collect_settings.py'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
		notify	 => Service['collect'],
		require	=> File['/opt/collect'],
	}

   file { '/opt/collect/psutil-2.2.0.tgz':
   	ensure    => present,
      content   => file('graphite/psutil-2.2.0.tgz'),
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
		require	=> File['/opt/collect'],
	}

	exec {'psutil':
		command => 'tar -zxf /opt/collect/psutil-2.2.0.tgz',
		cwd => '/usr/lib64/python2.6/site-packages',
		path => '/bin',
		creates => '/usr/lib64/python2.6/site-packages/psutil.done',
		require => File['/opt/collect/psutil-2.2.0.tgz'],
	}

	service { 'collect':
		ensure	=> running,
		enable	=> true,
		require	=> [ 
							File['/opt/collect/collect.py'],
							File['/opt/collect/settings.py'],
							File['/etc/init.d/collect'],
							Exec['psutil'],
						],
	}

}
