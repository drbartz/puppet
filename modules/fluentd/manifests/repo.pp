class logstash::repo {
	file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-logstash' :
		ensure		=> present,
		content	=> file('logstash/RPM-GPG-KEY-logstash'),
		owner		=> "root",
		group		=> "root",
		mode		=> 644,
	}

	file { '/etc/yum.repos.d/logstash.repo' :
		ensure		=> present,
		content	=> file('logstash/logstash.repo'),
		owner		=> "root",
		group		=> "root",
		mode		=> 644,
	}
}
