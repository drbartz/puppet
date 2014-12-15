class basic::localtime {
	file { '/etc/localtime':
		ensure    => link,
		target    => "/usr/share/zoneinfo/Europe/Madrid",
	}
}
