class graphite::config {

   file { '/etc/httpd/conf.d/graphite.conf':
   	ensure    => present,
      content   => file('graphite/http_graphite.conf'),
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
		notify	 => Service['carbon-cache']
	}

   file { '/etc/sysconfig/iptables':
   	ensure    => present,
      content   => file('graphite/iptables'),
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
		notify	=> Service['iptables'],
	}

   file { '/etc/init.d/carbon-cache':
   	ensure    => present,
      content   => file('graphite/init_carbon-cache'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
		notify	 => Service['carbon-cache']
	}

   file { '/opt/graphite/conf/graphite.wsgi':
   	ensure    => present,
      content   => file('graphite/graphite.wsgi'),
		mode      => '0755',
		owner     => 'apache',
		group     => 'apache',
		notify	 => Service['httpd']
	}

   file { '/opt/graphite/conf/storage-schemas.conf':
   	ensure    => present,
      content   => file('graphite/storage-schemas.conf'),
		mode      => '0644',
		owner     => 'apache',
		group     => 'apache',
		notify	 => Service['carbon-cache']
	}

   file { '/opt/graphite/conf/carbon.conf':
   	ensure    => present,
      content   => file('graphite/carbon.conf'),
		mode      => '0644',
		owner     => 'apache',
		group     => 'apache',
		notify	 => Service['carbon-cache']
	}

   file { '/opt/graphite/conf/storage-aggregation.conf':
   	ensure    => present,
      content   => file('graphite/storage-aggregation.conf'),
		mode      => '0644',
		owner     => 'apache',
		group     => 'apache',
		notify	 => Service['carbon-cache']
	}

	service { 'httpd':
		ensure	=> running,
		enable	=> true,
		require	=> File['/opt/graphite/conf/graphite.wsgi']
	}

	service { 'iptables':
		ensure	=> running,
		enable	=> true,
		require	=> File['/etc/sysconfig/iptables'],
	}

	service { 'carbon-cache':
		ensure	=> running,
		enable	=> true,
		require	=> [ 
							File['/etc/init.d/carbon-cache'],
							File['/opt/graphite/conf/carbon.conf'],
							File['/opt/graphite/conf/storage-aggregation.conf'],
							File['/opt/graphite/conf/storage-schemas.conf'],
						],
	}

	# iptables is the last service executed by install, so, lets keep the chain ;-)
	Service['iptables'] -> Service['carbon-cache'] -> Service['httpd']

}
