class basic::hosts {
	file { '/etc/hosts':
		ensure    => present,
		content   => file('basic/hosts'),
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
	}

}
