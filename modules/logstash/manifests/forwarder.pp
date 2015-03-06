class logstash::forwarder {

    package { 'golang':
        ensure  => present,
    }

	file { "/opt/logstash-forwarder/logstash-forwarder.conf":
		owner 	=> "root",
		group 	=> "root",
		mode    => 0644,
		notify	=> Service['logstash-forwarder'],
		require	=> Exec['/tmp/.install_logstash-forwarder.sh'],
		content 	=> file('logstash/logstash-forwarder.conf'),
	}
    exec { '/tmp/.install_logstash-forwarder.sh' :
        cwd     => "/tmp",
        creates => '/tmp/logstash-forwarder/.install',
        require =>  [
            Package['golang'],
            File['/tmp/.install_logstash-forwarder.sh'],
        ],
    }

    file { "/tmp/.install_logstash-forwarder.sh":
		owner 	=> "root",
		group 	=> "root",
		mode    => 0755,
		notify	=> Service['logstash-forwarder'],
		content => file('logstash/install_logstash-forwarder.sh'),
    }
        
	file { "/opt/logstash-forwarder/logstash-forwarder.key":
		owner 	=> "root",
		group 	=> "root",
		mode    => 0644,
		notify	=> Service['logstash-forwarder'],
		require	=> Exec["/tmp/.install_logstash-forwarder.sh"],
		content 	=> file('logstash/logstash-forwarder.key'),
	}

	file { "/opt/logstash-forwarder/logstash-forwarder.crt":
		owner 	=> "root",
		group 	=> "root",
		mode    => 0644,
		notify	=> Service['logstash-forwarder'],
		require	=> Exec['/tmp/.install_logstash-forwarder.sh'],
		content 	=> file('logstash/logstash-forwarder.crt'),
	}

	file { "/etc/init.d/logstash-forwarder":
		owner 	=> "root",
		group 	=> "root",
		mode    => 0755,
		notify	=> Service['logstash-forwarder'],
		require	=> Exec['/tmp/.install_logstash-forwarder.sh'],
		content 	=> file('logstash/init_logstash-forwarder'),
	}

	service { 'logstash-forwarder':
		enable  => 'true',
		ensure  => 'running',
		require => [
			File["/etc/init.d/logstash-forwarder"], 
			File["/opt/logstash-forwarder/logstash-forwarder.key"], 
			File["/opt/logstash-forwarder/logstash-forwarder.crt"], 
			File["/opt/logstash-forwarder/logstash-forwarder.conf"], 
		],
	}

}
