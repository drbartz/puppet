class puppet::client {
	file {'/etc/puppet/puppet.conf':
		ensure => present,
		content   => file('puppet/puppet.conf'),
		notify => Service['puppet'],
	}

	package {'puppet':
		ensure => installed, 
	}

	service { 'puppet':
		ensure	=> running,
		enable	=> true,
		require	=> Package['puppet']
	}
}

