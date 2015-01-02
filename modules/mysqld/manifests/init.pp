class mysqld {

	group { 'mysql':
		ensure => present,
	}

	user { 'mysql':
		ensure     => present,
		gid        => 'mysql',
		groups     => ['mysql'],
		membership => minimum,
		shell      => '/sbin/nologin',
		require    => Group['mysql'],
	}

	file { '/usr/bin/mysql_secure_installation_ChangeMe':
		ensure 	=> present,
		content	=> file('mysqld/mysql_secure_installation_ChangeMe'),
		mode		=> 755,
		owner		=> "root",
		group		=> "root",
	}

	exec { 'Cleanup MySQL':
		command	=> '/usr/bin/mysql_secure_installation_ChangeMe',
		cwd		=> '/usr/bin',
		creates	=> '/usr/bin/mysql_secure_installation_ChangeMe.tmp',
	}

	package { 'mysql-server':
		ensure	=> present,
	}

	service { 'mysqld':
		ensure		=> running,
		enable		=> true,
		hasstatus	=> 'true',
		hasrestart	=> 'true',
		require		=> Package['mysql-server'],
	}

	Service['mysqld'] -> File['/usr/bin/mysql_secure_installation_ChangeMe'] -> Exec['Cleanup MySQL']
}

