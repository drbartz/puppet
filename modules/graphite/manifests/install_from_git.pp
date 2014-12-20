class graphite::install_from_git {
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

	exec { "/opt/graphite/install_graphite.sh":
		cwd     => "/opt/graphite",
	}

   file { '/opt/graphite/install_graphite.sh':
   	ensure    => present,
      content   => file('graphite/install_graphite.sh'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
	}
}