class httpd {

	group { 'apache':
		ensure => present,
	}

	user { 'apache':
		ensure     => present,
		gid        => 'apache',
		groups     => ['apache'],
		membership => minimum,
		shell      => '/sbin/nologin',
		require    => Group['apache'],
	}

	package { 'httpd':
		ensure	=> present,
	}

	service { 'httpd':
		ensure		=> running,
		enable		=> true,
		hasstatus	=> 'true',
		hasrestart	=> 'true',
		require		=> Package['httpd'],
	}

}

