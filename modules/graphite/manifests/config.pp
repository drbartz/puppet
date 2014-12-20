class graphite::config {

   file { '/opt/graphite':
   	ensure    => directory,
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
