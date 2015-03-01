class logstash {

	include logstash::repo
	file { "/etc/logstash/conf.d/logstash.conf":
		owner 	=> "logstash",
		group 	=> "logstash",
		mode    => 0644,
		notify	=> Service['logstash'],
		require	=> [
			Class['logstash::repo'],
			Package['logstash'],
		],
		content 	=> file('logstash/logstash.conf'),
	}

	file { "/etc/logstash/logstash-forwarder.key":
		owner 	=> "logstash",
		group 	=> "logstash",
		mode    => 0644,
		notify	=> Service['logstash'],
		require	=> File['/etc/logstash/conf.d/logstash.conf'],
		content 	=> file('logstash/logstash-forwarder.key'),
	}

	file { "/etc/logstash/logstash-forwarder.crt":
		owner 	=> "logstash",
		group 	=> "logstash",
		mode    => 0644,
		notify	=> Service['logstash'],
		require	=> File['/etc/logstash/conf.d/logstash.conf'],
		content 	=> file('logstash/logstash-forwarder.crt'),
	}

	service { 'logstash':
		enable  => 'true',
		ensure  => 'running',
		require => [
			File["/etc/logstash/conf.d/logstash.conf"], 
			Package["logstash"],
		],
	}

	package { "logstash":
		ensure  => present,
		require	=> [
            Class['logstash::repo'],
            Package['java-1.7.0-openjdk'],
        ],
    }

}
