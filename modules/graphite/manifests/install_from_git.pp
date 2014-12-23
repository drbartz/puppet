class graphite::install_from_git {
	package { [ 'epel-release', 'git' , 'libffi-devel', 'mod_wsgi' ]:
		ensure => installed,
	}
	package { [ 'python-pip', 'pycairo', 'Django14', 'python-ldap', 'python-memcached', 'python-sqlite2', 'bitmap', 'bitmap-fonts-compat', 'python-devel', 'python-crypto', 'pyOpenSSL', 'gcc', 'python-zope-filesystem', 'python-zope-interface',  'gcc-c++', 'zlib-static', 'MySQL-python', 'python-txamqp', 'python-setuptools', 'python-psycopg2', 'dejavu-sans-fonts', 'dejavu-serif-fonts']:
		ensure => installed,
		require => Package['epel-release'],
	}

	exec { '/opt/graphite/install_graphite.sh' :
		cwd     => "/opt/graphite",
	}

	file { '/opt/graphite':
		ensure    => directory,
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
	
	group { 'carbon':
		ensure => present,
	}

	group { 'apache':
		ensure => present,
	}

	user { 'carbon':
		ensure     => present,
		gid        => 'carbon',
		groups     => ['root', 'carbon', 'apache'],
		membership => minimum,
		shell      => '/sbin/nologin',
		require    => [ Group['carbon'], Group['apache'] ]
	}


	File['/opt/graphite'] -> Exec['/opt/graphite/install_graphite.sh']  -> Service['iptables']
}
