class basic::vim {
	package {['vim-common','vim-enhanced']: ensure => installed }
	file { '/root/.vimrc':
		ensure    => present,
		content   => file('basic/vimrc'),
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
	}
	file { '/root/.bashrc':
		ensure    => present,
		content   => file('basic/bashrc'),
		mode      => '0644',
		owner     => 'root',
		group     => 'root',
	}
}
