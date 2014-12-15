class puppet::client {
	package {'puppet':
		ensure => installed, 
	}
	service { 'puppet':
		ensure => running,
		enable => true,
	}
}

