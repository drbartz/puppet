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
	package { [ 'epel-release', 'git' , 'libffi-devel', 'mod_wsgi' ]:
		ensure => installed,
	}
	package { 'httpd':
		ensure => installed,
		before => File['/etc/httpd/conf.d/graphite.conf'],
	}
	include basic
	include puppet::client
	#include graphite

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

	class { 'python' :
		version    => 'system',
		pip        => true,
		dev        => true,
		virtualenv => false,
		gunicorn   => false,
	}

	python::requirements { '/opt/graphite/requirements.txt' :
		owner      => 'root',
	}

   python::pip { ['whisper', 'carbon', 'graphite-web']:
	  ensure		=> present,
   }

	exec { "/usr/bin/python /opt/graphite/webapp/graphite/manage.py syncdb":
		cwd     => "/opt/graphite",
		path    => ["/usr/bin", "/usr/sbin"]
	}

	service { 'httpd':
		ensure => running,
		enable => true,
		subscribe => File['/etc/httpd/conf.d/graphite.conf'],
	}

}
