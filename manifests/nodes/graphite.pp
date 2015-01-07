# install graphite from git 
node /graphite01.*/ {
	include basic
	include puppet::client
	include graphite::server_git
	#include graphite::install_from_git
	#include graphite::config
	#Class['graphite::install_from_git'] -> Class['graphite::config']
}

# install graphite from epel rpm packages
node /graphite02.*$/ {
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
