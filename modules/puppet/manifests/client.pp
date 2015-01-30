class puppet::client {
	file {'/etc/puppet/puppet.conf':
		ensure => present,
		content   => file('puppet/puppet.conf'),
		notify => Service['puppet'],
	}

    file {'/etc/yum.conf':
        ensure  => present,
        content => file('puppet/client_yum.conf'),
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

