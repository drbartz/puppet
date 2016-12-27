class errbot {
	
	package { ['python34','python34-devel','python34-setuptools','python-pip']:
		ensure	=> installed,
		require	=> [
			Package['epel-release'], 
		],
	}

	file {'/etc/errbot':
		ensure 	=> directory,
	}

	file {'/etc/errbot/data':
		ensure 	=> directory,
		require	=> [
			File['/etc/errbot/data'],
		],
	}

    file { '/etc/errbot/.install_errbot.sh':
        ensure    => present,
        content   => file('errbot/install_errbot.sh'),
        mode      => '0755',
        owner     => 'root',
        group     => 'root',
    }

	exec {'Post install errbot':
		command	=> '/etc/errbot/.install_errbot.sh',
		creates	=> '/etc/errbot/.install_errbot.done',
		require	=> [
			File['/etc/errbot/.install_errbot.sh'],
            Package['python34'],
			Package['python34-devel'],
            Package['python34-setuptools'],
            Package['python-pip'],
		],
	}

}
