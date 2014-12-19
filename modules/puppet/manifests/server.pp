class puppet::server {
	file { '/etc/puppet/autosign.conf':
		ensure    => present,
		content   => file('puppet/autosign.conf'),
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
	}
	file { '/root/clean_cert.sh':
		ensure    => present,
		content   => file('puppet/clean_cert.sh'),
		mode      => '0755',
		owner     => 'root',
		group     => 'root',
	}
}
