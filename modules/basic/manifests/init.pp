class basic {
	include basic::localtime
	include basic::hosts
	include basic::vim
	package { ['telnet', 'bind-utils']:
		ensure	=> present,
	}
}
