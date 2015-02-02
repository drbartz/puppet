class puppet::client {
	file {'/etc/puppet/puppet.conf':
		ensure => present,
		content   => file('puppet/puppet.conf'),
		notify => Service['puppet'],
	}

#    file {'/etc/yum.conf':
#        ensure  => present,
#        content => file('puppet/client_yum.conf'),
#    }

#    file {'/etc/yum.repos.d/autocache.repo':
#        ensure  => present,
#        owner   => 'root',
#        group   => 'root',
#        mode    => '0644',
#        content => file('puppet/autocache.repo'),
#    }

	package {'puppet':
		ensure => installed, 
	}

	service { 'puppet':
		ensure	=> running,
		enable	=> true,
		require	=> Package['puppet']
	}
}

