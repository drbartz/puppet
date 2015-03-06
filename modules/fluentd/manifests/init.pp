class logstash {

	include logstash::repo

	file { "/etc/logstash/conf.d/10-messages.conf":
		owner 	=> logstash,
		group 	=> logstash,
		mode		=> 0644,
		notify	=> Service['logstash'],
		require	=> [
			Class['logstash::repo'],
			Package['logstash'],
		],
		content 	=> file('logstash/10-messages.conf'),
	}

	service { 'logstash':
		enable=> 'true',
		ensure=> 'running',
		require => [
			File["/etc/logstash/conf.d/10-messages.conf"], 
			Package["logstash"],
		],
	}

	package { "logstash":
		ensure=> present,
		require	=> Class['logstash::repo'],
    }

    package { "jdk":
        ensure  => present,
	}
}
