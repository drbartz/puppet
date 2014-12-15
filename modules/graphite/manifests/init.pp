class graphite {
	package { 'epel-release':
		ensure => installed,
	}

	package { [ 'graphite-web', 'python-carbon']:
		ensure => installed,
		require => Package['epel-release'],
	}
}
