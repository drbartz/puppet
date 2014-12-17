class puppet::server {
	file { '/etc/puppet/autosign.conf':
		ensure    => present,
		content   => file('puppet/autosign.conf'),
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
	}
}
