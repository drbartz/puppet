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
	Class['graphite::install_from_git'] ~> Class['graphite::config']
}

node /graphite03.*/ {
	package { [ 'epel-release', 'git' , 'libffi-devel', 'mod_wsgi' ]:
		ensure => installed,
	}
	package { [ 'python-pip', 'pycairo', 'Django14', 'python-ldap', 'python-memcached', 'python-sqlite2', 'bitmap', 'bitmap-fonts-compat' ]:
		ensure => installed,
		require => Package['epel-release'],
	}
	package { [ 'python-devel', 'python-crypto', 'pyOpenSSL', 'gcc', 'python-zope-filesystem', 'python-zope-interface',  'gcc-c++']:
		ensure => installed,
		require => Package['epel-release'],
	}
	package { [ 'zlib-static', 'MySQL-python', 'python-txamqp', 'python-setuptools', 'python-psycopg2']:
		ensure => installed,
		require => Package['epel-release'],
	}
	package { 'httpd':
		ensure => installed,
		before => File['/etc/httpd/conf.d/graphite.conf'],
	}
	include basic
	include puppet::client
	#include graphite
	
	exec { "/opt/graphite/install_graphite.sh":
		cwd     => "/opt/graphite",
	}

   file { '/opt/graphite':
   	ensure    => directory,
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
	}

   file { '/opt/graphite/requirements.txt':
   	ensure    => present,
      content   => file('graphite/requirements.txt'),
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
	}

   file { '/etc/httpd/conf.d/graphite.conf':
   	ensure    => present,
      content   => file('graphite/http_graphite.conf'),
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
	}

   file { '/etc/sysconfig/iptables':
   	ensure    => present,
      content   => file('graphite/iptables'),
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
	}

   file { '/opt/graphite/install_graphite.sh':
   	ensure    => present,
      content   => file('graphite/install_graphite.sh'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
	}

   file { '/etc/init.d/carbon-cache':
   	ensure    => present,
      content   => file('graphite/init_carbon-cache'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
	}

   file { '/opt/graphite/conf/graphite.wsgi':
   	ensure    => present,
      content   => file('graphite/graphite.wsgi'),
		mode      => '0755',
		owner     => 'apache',
		group     => 'apache',
	}

   file { '/opt/graphite/conf/storage-schemas.conf':
   	ensure    => present,
      content   => file('graphite/storage-schemas.conf'),
		mode      => '0644',
		owner     => 'apache',
		group     => 'apache',
	}

   file { '/opt/graphite/conf/carbon.conf':
   	ensure    => present,
      content   => file('graphite/carbon.conf'),
		mode      => '0644',
		owner     => 'apache',
		group     => 'apache',
	}

   file { '/opt/graphite/conf/storage-aggregation.conf':
   	ensure    => present,
      content   => file('graphite/storage-aggregation.conf'),
		mode      => '0644',
		owner     => 'apache',
		group     => 'apache',
	}

	service { 'httpd':
		ensure => running,
		enable => true,
		subscribe => File['/etc/httpd/conf.d/graphite.conf'],
	}

	service { 'iptables':
		ensure => running,
		enable => true,
		subscribe => File['/etc/sysconfig/iptables'],
	}

	service { 'carbon-cache':
		ensure => running,
		enable => true,
		subscribe => File['/opt/graphite/conf/carbon.conf'],
	}
}
