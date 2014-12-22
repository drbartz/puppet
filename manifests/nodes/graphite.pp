node /graphite01.*$/ {
	package { [ 'epel-release', 'httpd', 'mod_wsgi']:
		ensure => installed,
	}
	package { [ 'graphite-web', 'python-carbon' ]:
		ensure => installed,
		require => Package['epel-release'],
	}
	include basic
	include puppet::client
	#include graphite
}

node /graphite02.*/ {
	include basic
	include puppet::client
	include graphite::install_from_git
	include graphite::config
	Class['graphite::install_from_git'] -> Class['graphite::config']
}

